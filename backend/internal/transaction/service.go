package transaction

import (
	"context"
	"errors"
	"log/slog"
	"strings"
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
	"github.com/equinox-jj/MonAI/backend/internal/wallet"
)

// userLocation is the timezone for "today" and the default month. Users have
// no stored timezone yet, so the PRD default applies. Asia/Jakarta has no DST,
// so a fixed zone avoids depending on tzdata.
var userLocation = time.FixedZone("Asia/Jakarta", 7*60*60)

// receiptExtensions lists the allowed receipt content types and the file
// extension used in their object keys.
var receiptExtensions = map[string]string{
	"image/jpeg": ".jpg",
	"image/webp": ".webp",
}

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
	CreateReceiptUploadURL(ctx context.Context, userID uuid.UUID, req ReceiptUploadURLRequest) (UploadURLResponse, error)
}

type service struct {
	repo       Repository
	wallets    wallet.Repository
	categories category.Repository
	tx         database.TxManager
	store      storage.Storage
	log        *slog.Logger
	bucket     string // private bucket holding receipts
	now        func() time.Time
}

func NewService(
	repo Repository,
	wallets wallet.Repository,
	categories category.Repository,
	tx database.TxManager,
	store storage.Storage,
	log *slog.Logger,
	cfg config.Config,
) Service {
	return &service{
		repo:       repo,
		wallets:    wallets,
		categories: categories,
		tx:         tx,
		store:      store,
		log:        log,
		bucket:     cfg.MinIO.BucketPrivate,
		now:        time.Now,
	}
}

func (s *service) List(ctx context.Context, userID uuid.UUID, q ListTransactionsQuery) ([]TransactionResponse, httpx.CursorMeta, error) {
	from, err := s.monthStart(q.Month)
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
	date, err := s.parseDate(req.Date)
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
		if err := s.checkReceipt(ctx, userID, *t.ReceiptKey); err != nil {
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
		return TransactionResponse{}, ErrNoFields
	}

	var t *Transaction
	err := s.tx.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		if t, err = s.repo.FindByID(ctx, userID, id); err != nil {
			return err
		}
		prev := *t

		if err := s.applyUpdate(t, req); err != nil {
			return err
		}
		if err := s.checkRefs(ctx, t, &prev); err != nil {
			return err
		}
		if t.ReceiptKey != nil && !equalPtr(t.ReceiptKey, prev.ReceiptKey) {
			if err := s.checkReceipt(ctx, userID, *t.ReceiptKey); err != nil {
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

func (s *service) CreateReceiptUploadURL(ctx context.Context, userID uuid.UUID, req ReceiptUploadURLRequest) (UploadURLResponse, error) {
	ext, ok := receiptExtensions[req.ContentType]
	if !ok {
		return UploadURLResponse{}, ErrReceiptType
	}

	key := receiptPrefix(userID) + uuid.NewString() + ext
	url, err := s.store.PresignPut(ctx, s.bucket, key, ReceiptURLExpiresIn)
	if err != nil {
		return UploadURLResponse{}, err
	}

	return ToUploadURLResponse(url, key, req.ContentType, ReceiptURLExpiresIn), nil
}

// applyUpdate applies the fields present in req to t.
func (s *service) applyUpdate(t *Transaction, req UpdateTransactionRequest) error {
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
		date, err := s.parseDate(*req.Date)
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

// checkReceipt verifies that key is the user's uploaded receipt with an
// allowed type and size. A rejected object is deleted so it does not linger
// in the bucket.
func (s *service) checkReceipt(ctx context.Context, userID uuid.UUID, key string) error {
	if !isOwnReceiptKey(userID, key) {
		return ErrReceiptKeyInvalid
	}

	info, err := s.store.Stat(ctx, s.bucket, key)
	if errors.Is(err, storage.ErrObjectNotFound) {
		return ErrReceiptNotFound
	}
	if err != nil {
		return err
	}

	var reject error
	if _, ok := receiptExtensions[info.ContentType]; !ok {
		reject = ErrReceiptType
	} else if info.Size > ReceiptMaxSizeBytes {
		reject = ErrReceiptTooLarge
	}
	if reject != nil {
		s.deleteObject(ctx, key)
	}

	return reject
}

// parseDate parses a YYYY-MM-DD date and rejects dates after today in the
// user's timezone.
func (s *service) parseDate(v string) (time.Time, error) {
	d, err := time.Parse(dateLayout, v)
	if err != nil {
		return time.Time{}, ErrDateInvalid
	}
	if d.After(s.today()) {
		return time.Time{}, ErrDateInFuture
	}

	return d, nil
}

// monthStart returns the first day of a YYYY-MM month, or of the current
// month in the user's timezone when v is empty.
func (s *service) monthStart(v string) (time.Time, error) {
	if v == "" {
		y, m, _ := s.today().Date()
		return time.Date(y, m, 1, 0, 0, 0, 0, time.UTC), nil
	}

	d, err := time.Parse("2006-01", v)
	if err != nil {
		return time.Time{}, ErrMonthInvalid
	}

	return d, nil
}

// today is the user's current local date at UTC midnight, comparable with
// DATE values.
func (s *service) today() time.Time {
	y, m, d := s.now().In(userLocation).Date()
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
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

func receiptPrefix(userID uuid.UUID) string { return "receipts/" + userID.String() + "/" }

// isOwnReceiptKey reports whether key is a single object directly under the
// user's receipt prefix, rejecting path tricks such as "..".
func isOwnReceiptKey(userID uuid.UUID, key string) bool {
	name, ok := strings.CutPrefix(key, receiptPrefix(userID))
	return ok && name != "" && !strings.ContainsAny(name, "/\\") && name != "." && name != ".."
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
