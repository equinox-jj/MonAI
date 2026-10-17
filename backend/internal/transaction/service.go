package transaction

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"strings"
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
	"github.com/equinox-jj/MonAI/backend/internal/platform/period"
	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
	"github.com/equinox-jj/MonAI/backend/internal/wallet"
)

// receiptRule limits receipt uploads and maps their types to key extensions.
var receiptRule = httpx.FileRule{
	MaxBytes: ReceiptMaxSizeBytes,
	Types: map[string]string{
		"image/jpeg": ".jpg",
		"image/webp": ".webp",
	},
}

type (
	// Wallets, Categories and Timezones are the parts of other features the
	// service uses, so a test fake implements one method instead of a whole
	// repository. module.go adapts the real repositories to them.
	Wallets interface {
		FindByID(ctx context.Context, userID, id uuid.UUID) (*wallet.Wallet, error)
	}

	Categories interface {
		FindByID(ctx context.Context, userID, id uuid.UUID) (*category.Category, error)
	}

	Timezones interface {
		// Timezone returns the user's IANA timezone name.
		Timezone(ctx context.Context, userID uuid.UUID) (string, error)
	}
)

type Service interface {
	// List returns one page of the user's transactions for a month (default:
	// the current one), newest first, with the cursor for the next page.
	List(ctx context.Context, userID uuid.UUID, q ListTransactionsQuery) ([]TransactionResponse, httpx.CursorMeta, error)
	Get(ctx context.Context, userID, id uuid.UUID) (TransactionResponse, error)
	// Create checks the type's shape, that the wallets and category belong to
	// the user, that new wallets are not archived, that the date is not in
	// the future and that the receipt was uploaded.
	Create(ctx context.Context, userID uuid.UUID, req CreateTransactionRequest) (TransactionResponse, error)
	// Update applies the fields present in req; the merged result must pass
	// the same rules as Create. Wallets the transaction already uses may stay
	// even if archived.
	Update(ctx context.Context, userID, id uuid.UUID, req UpdateTransactionRequest) (TransactionResponse, error)
	// Delete soft-deletes the transaction; Restore undoes it.
	Delete(ctx context.Context, userID, id uuid.UUID) error
	// Restore fails with ErrWalletArchived if one of the transaction's
	// wallets was archived after the delete.
	Restore(ctx context.Context, userID, id uuid.UUID) (TransactionResponse, error)
	// UploadReceipt checks and stores f under the user's pending receipt
	// prefix and returns its key for receipt_key. Pending uploads that no
	// transaction references expire after a day.
	UploadReceipt(ctx context.Context, userID uuid.UUID, f httpx.File) (ReceiptUploadResponse, error)
}

type service struct {
	repo       Repository
	wallets    Wallets
	categories Categories
	users      Timezones
	tx         database.TxManager
	store      storage.Storage
	log        *slog.Logger
	bucket     string // private bucket holding receipts
	now        func() time.Time
	zones      period.Locations
}

func NewService(
	repo Repository,
	wallets Wallets,
	categories Categories,
	users Timezones,
	tx database.TxManager,
	store storage.Storage,
	log *slog.Logger,
	cfg config.Config,
) Service {
	return &service{
		repo:       repo,
		wallets:    wallets,
		categories: categories,
		users:      users,
		tx:         tx,
		store:      store,
		log:        log,
		bucket:     cfg.MinIO.BucketPrivate,
		now:        time.Now,
	}
}

func (s *service) List(ctx context.Context, userID uuid.UUID, q ListTransactionsQuery) ([]TransactionResponse, httpx.CursorMeta, error) {
	from, err := s.monthStart(ctx, userID, q.Month)
	if err != nil {
		return nil, httpx.CursorMeta{}, err
	}

	limit := q.Limit
	if limit < 1 || limit > MaxLimit {
		limit = DefaultLimit
	}

	filter := ListFilter{
		From:       from,
		To:         from.AddDate(0, 1, 0),
		WalletID:   q.WalletID,
		CategoryID: q.CategoryID,
		Type:       q.Type,
		Query:      strings.TrimSpace(q.Q),
		Limit:      limit + 1, // one extra row tells whether another page exists
	}
	if q.Cursor != "" {
		if filter.After, err = decodeCursor(q.Cursor); err != nil {
			return nil, httpx.CursorMeta{}, err
		}
	}

	ts, err := s.repo.List(ctx, userID, filter)
	if err != nil {
		return nil, httpx.CursorMeta{}, err
	}

	meta := httpx.CursorMeta{Limit: limit}
	if len(ts) > limit {
		ts = ts[:limit]
		next := encodeCursor(&ts[limit-1])
		meta.NextCursor = &next
		meta.HasMore = true
	}

	out := make([]TransactionResponse, len(ts))
	for i := range ts {
		if out[i], err = s.toResponse(ctx, &ts[i]); err != nil {
			return nil, httpx.CursorMeta{}, err
		}
	}

	return out, meta, nil
}

func (s *service) Get(ctx context.Context, userID, id uuid.UUID) (TransactionResponse, error) {
	t, err := s.repo.FindByID(ctx, userID, id)
	if err != nil {
		return TransactionResponse{}, err
	}

	return s.toResponse(ctx, t)
}

func (s *service) Create(ctx context.Context, userID uuid.UUID, req CreateTransactionRequest) (TransactionResponse, error) {
	today, err := s.today(ctx, userID)
	if err != nil {
		return TransactionResponse{}, err
	}
	date, err := parseDate(req.Date, today)
	if err != nil {
		return TransactionResponse{}, err
	}

	t := &Transaction{
		UserID:     userID,
		Type:       req.Type,
		Amount:     req.Amount,
		WalletID:   req.WalletID,
		ToWalletID: req.ToWalletID,
		CategoryID: req.CategoryID,
		Date:       date,
		Note:       trimToNil(req.Note),
		Merchant:   trimToNil(req.Merchant),
		ReceiptKey: req.ReceiptKey,
		Source:     SourceManual,
	}
	if req.Source != nil {
		t.Source = *req.Source
	}

	if err := s.checkRefs(ctx, t, nil); err != nil {
		return TransactionResponse{}, err
	}
	if t.ReceiptKey != nil {
		if t.ReceiptKey, err = s.attachReceipt(ctx, userID, *t.ReceiptKey); err != nil {
			return TransactionResponse{}, err
		}
	}

	if err := s.repo.Create(ctx, t); err != nil {
		return TransactionResponse{}, err
	}

	return s.toResponse(ctx, t)
}

func (s *service) Update(ctx context.Context, userID, id uuid.UUID, req UpdateTransactionRequest) (TransactionResponse, error) {
	if req.empty() {
		return TransactionResponse{}, httpx.ErrNoFields
	}

	var t *Transaction
	err := s.tx.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		if t, err = s.repo.FindByIDForUpdate(ctx, userID, id); err != nil {
			return err
		}
		prev := *t

		today, err := s.today(ctx, userID)
		if err != nil {
			return err
		}
		if err := applyUpdate(t, req, today); err != nil {
			return err
		}
		if err := s.checkRefs(ctx, t, &prev); err != nil {
			return err
		}
		if t.ReceiptKey != nil && !equalPtr(t.ReceiptKey, prev.ReceiptKey) {
			if t.ReceiptKey, err = s.attachReceipt(ctx, userID, *t.ReceiptKey); err != nil {
				return err
			}
		}

		return s.repo.Update(ctx, t)
	})
	if err != nil {
		return TransactionResponse{}, err
	}

	return s.toResponse(ctx, t)
}

func (s *service) Delete(ctx context.Context, userID, id uuid.UUID) error {
	return s.repo.Delete(ctx, userID, id)
}

func (s *service) Restore(ctx context.Context, userID, id uuid.UUID) (TransactionResponse, error) {
	var t *Transaction
	err := s.tx.WithinTx(ctx, func(ctx context.Context) error {
		deleted, err := s.repo.FindDeletedByID(ctx, userID, id)
		if err != nil {
			return err
		}

		walletIDs := []uuid.UUID{deleted.WalletID}
		if deleted.ToWalletID != nil {
			walletIDs = append(walletIDs, *deleted.ToWalletID)
		}
		for _, wid := range walletIDs {
			w, err := s.wallets.FindByID(ctx, userID, wid)
			if err != nil {
				return err
			}
			if w.IsArchived {
				return ErrWalletArchived
			}
		}

		t, err = s.repo.Restore(ctx, userID, id)
		return err
	})
	if err != nil {
		return TransactionResponse{}, err
	}

	return s.toResponse(ctx, t)
}

func (s *service) UploadReceipt(ctx context.Context, userID uuid.UUID, f httpx.File) (ReceiptUploadResponse, error) {
	ext, err := receiptRule.Check(f)
	if err != nil {
		return ReceiptUploadResponse{}, err
	}

	key := storage.NewKey(storage.PendingReceiptPrefix(userID), ext)
	if err := s.store.Put(ctx, s.bucket, key, f.Body, f.Size, f.ContentType); err != nil {
		return ReceiptUploadResponse{}, err
	}

	return ReceiptUploadResponse{ReceiptKey: key}, nil
}

// applyUpdate applies the fields present in req to t. today is the user's
// local date, for the date check.
func applyUpdate(t *Transaction, req UpdateTransactionRequest, today time.Time) error {
	if req.Type != nil {
		t.Type = *req.Type
	}
	if req.Amount != nil {
		t.Amount = *req.Amount
	}
	if req.WalletID != nil {
		t.WalletID = *req.WalletID
	}
	if req.ToWalletID.Set {
		t.ToWalletID = req.ToWalletID.Value
	}
	if req.CategoryID.Set {
		t.CategoryID = req.CategoryID.Value
	}
	if req.Date != nil {
		date, err := parseDate(*req.Date, today)
		if err != nil {
			return err
		}
		t.Date = date
	}
	if req.Note.Set {
		t.Note = trimToNil(req.Note.Value)
	}
	if req.Merchant.Set {
		t.Merchant = trimToNil(req.Merchant.Value)
	}
	if req.ReceiptKey.Set {
		t.ReceiptKey = req.ReceiptKey.Value
	}

	return nil
}

// checkRefs checks t's shape for its type and that its wallets and category
// belong to the user. Wallets are checked for archiving only when they are
// new compared to prev (nil on create).
func (s *service) checkRefs(ctx context.Context, t, prev *Transaction) error {
	if err := checkShape(t); err != nil {
		return err
	}

	newWallet := prev == nil || t.WalletID != prev.WalletID
	if err := s.checkWallet(ctx, t.UserID, t.WalletID, newWallet, ErrWalletInvalid, ErrWalletArchive); err != nil {
		return err
	}

	if t.ToWalletID != nil {
		newToWallet := prev == nil || !equalPtr(t.ToWalletID, prev.ToWalletID)
		if err := s.checkWallet(ctx, t.UserID, *t.ToWalletID, newToWallet, ErrToWalletInvalid, ErrToWalletArchive); err != nil {
			return err
		}
	}

	if t.CategoryID != nil {
		c, err := s.categories.FindByID(ctx, t.UserID, *t.CategoryID)
		if errors.Is(err, category.ErrNotFound) {
			return ErrCategoryInvalid
		}
		if err != nil {
			return err
		}
		if string(c.Type) != string(t.Type) {
			return ErrCategoryInvalid
		}
	}

	return nil
}

// checkWallet verifies that the wallet belongs to the user and, when
// checkArchived is set, that it is not archived. A missing wallet is a
// validation error, not a 404, so it is not confused with the transaction.
func (s *service) checkWallet(ctx context.Context, userID, id uuid.UUID, checkArchived bool, invalid, archived error) error {
	w, err := s.wallets.FindByID(ctx, userID, id)
	if errors.Is(err, wallet.ErrNotFound) {
		return invalid
	}
	if err != nil {
		return err
	}
	if checkArchived && w.IsArchived {
		return archived
	}

	return nil
}

// checkShape enforces the type rules: transfers have a different destination
// wallet and no category; expense and income have a category and no
// destination.
func checkShape(t *Transaction) error {
	if t.Type == TypeTransfer {
		switch {
		case t.CategoryID != nil:
			return ErrCategoryBanned
		case t.ToWalletID == nil:
			return ErrToWalletNeeded
		case *t.ToWalletID == t.WalletID:
			return ErrToWalletSame
		}
		return nil
	}

	switch {
	case t.ToWalletID != nil:
		return ErrToWalletBanned
	case t.CategoryID == nil:
		return ErrCategoryNeeded
	}
	return nil
}

// attachReceipt returns the key to store for a receipt_key from the client.
// A key from UploadReceipt is pending: the object is copied out of the
// expiring pending prefix and the copy's key returned. A key already attached
// to one of the user's transactions is kept as is (a receipt can be shared).
// Type and size were checked by UploadReceipt.
func (s *service) attachReceipt(ctx context.Context, userID uuid.UUID, key string) (*string, error) {
	if _, ok := storage.ObjectName(storage.ReceiptPrefix(userID), key); ok {
		if err := s.statReceipt(ctx, key); err != nil {
			return nil, err
		}
		return &key, nil
	}

	name, ok := storage.ObjectName(storage.PendingReceiptPrefix(userID), key)
	if !ok {
		return nil, ErrReceiptKeyInvalid
	}

	attached := storage.ReceiptPrefix(userID) + name
	err := s.store.Copy(ctx, s.bucket, key, attached)
	if errors.Is(err, storage.ErrObjectNotFound) {
		// A retried request may have attached it already.
		if err := s.statReceipt(ctx, attached); err != nil {
			return nil, err
		}
		return &attached, nil
	}
	if err != nil {
		return nil, err
	}
	s.deleteObject(ctx, key)

	return &attached, nil
}

// statReceipt returns ErrReceiptNotFound when no object has key.
func (s *service) statReceipt(ctx context.Context, key string) error {
	_, err := s.store.Stat(ctx, s.bucket, key)
	if errors.Is(err, storage.ErrObjectNotFound) {
		return ErrReceiptNotFound
	}

	return err
}

// parseDate parses a YYYY-MM-DD date and rejects dates after today, the
// user's local date.
func parseDate(v string, today time.Time) (time.Time, error) {
	d, err := time.Parse(dateLayout, v)
	if err != nil {
		return time.Time{}, ErrDateInvalid
	}
	if d.After(today) {
		return time.Time{}, ErrDateInFuture
	}

	return d, nil
}

// monthStart returns the first day of a YYYY-MM month, or of the current
// month in the user's timezone when v is empty.
func (s *service) monthStart(ctx context.Context, userID uuid.UUID, v string) (time.Time, error) {
	if v == "" {
		today, err := s.today(ctx, userID)
		if err != nil {
			return time.Time{}, err
		}
		y, m, _ := today.Date()
		return time.Date(y, m, 1, 0, 0, 0, 0, time.UTC), nil
	}

	from, _, err := period.Month(v)
	if err != nil {
		return time.Time{}, ErrMonthInvalid
	}

	return from, nil
}

// today is the user's current local date in their stored timezone, at UTC
// midnight so it compares with DATE values.
func (s *service) today(ctx context.Context, userID uuid.UUID) (time.Time, error) {
	name, err := s.users.Timezone(ctx, userID)
	if err != nil {
		return time.Time{}, err
	}
	loc, err := s.zones.Load(name)
	if err != nil {
		return time.Time{}, fmt.Errorf("transaction: user timezone %q: %w", name, err)
	}

	return period.LocalDate(s.now(), loc), nil
}

// toResponse maps t with a presigned receipt URL.
func (s *service) toResponse(ctx context.Context, t *Transaction) (TransactionResponse, error) {
	var receiptURL *string
	if t.ReceiptKey != nil {
		url, err := s.store.PresignGet(ctx, s.bucket, *t.ReceiptKey, ReceiptURLExpiresIn)
		if err != nil {
			return TransactionResponse{}, err
		}
		receiptURL = &url
	}

	return ToTransactionResponse(t, receiptURL), nil
}

// deleteObject removes an object that is no longer referenced. A failure only
// leaves an orphan, so it is logged instead of failing the request.
func (s *service) deleteObject(ctx context.Context, key string) {
	if err := s.store.Delete(ctx, s.bucket, key); err != nil {
		s.log.ErrorContext(ctx, "transaction: delete object", "key", key, "error", err)
	}
}

// trimToNil trims s and turns a blank string into nil.
func trimToNil(s *string) *string {
	if s == nil {
		return nil
	}
	v := strings.TrimSpace(*s)
	if v == "" {
		return nil
	}
	return &v
}

func equalPtr[T comparable](a, b *T) bool {
	if a == nil || b == nil {
		return a == b
	}
	return *a == *b
}
