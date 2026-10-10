package ai

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/period"
	"github.com/equinox-jj/MonAI/backend/internal/provider"
	"github.com/equinox-jj/MonAI/backend/internal/wallet"
)

type Service interface {
	// ParseTransaction turns a quick-add phrase into validated drafts. It
	// never saves anything.
	ParseTransaction(ctx context.Context, userID uuid.UUID, req ParseTransactionRequest) (ParseTransactionResponse, error)
	// ParseReceipt turns receipt OCR text into one validated draft. It never
	// saves anything.
	ParseReceipt(ctx context.Context, userID uuid.UUID, req ParseReceiptRequest) (ParseReceiptResponse, error)
}

type service struct {
	parser     TransactionParser
	wallets    wallet.Repository
	categories category.Repository
	providers  provider.Repository
	timeout    time.Duration
	now        func() time.Time
	zones      period.Locations
}

func NewService(
	parser TransactionParser,
	wallets wallet.Repository,
	categories category.Repository,
	providers provider.Repository,
	cfg config.Config,
) Service {
	return &service{
		parser:     parser,
		wallets:    wallets,
		categories: categories,
		providers:  providers,
		timeout:    cfg.Gemini.Timeout,
		now:        time.Now,
	}
}

func (s *service) ParseTransaction(ctx context.Context, userID uuid.UUID, req ParseTransactionRequest) (ParseTransactionResponse, error) {
	in, ok, err := s.prepare(ctx, userID, req.Text, req.Today, req.Timezone)
	if err != nil {
		return ParseTransactionResponse{}, err
	}

	ctx, cancel := context.WithTimeout(ctx, s.timeout)
	defer cancel()

	raws, err := s.parser.ParseTransaction(ctx, in)
	if err != nil {
		return ParseTransactionResponse{}, providerError(err)
	}

	return ParseTransactionResponse{Drafts: ok.sanitizeDrafts(raws)}, nil
}

func (s *service) ParseReceipt(ctx context.Context, userID uuid.UUID, req ParseReceiptRequest) (ParseReceiptResponse, error) {
	in, ok, err := s.prepare(ctx, userID, req.OCRText, req.Today, req.Timezone)
	if err != nil {
		return ParseReceiptResponse{}, err
	}

	ctx, cancel := context.WithTimeout(ctx, s.timeout)
	defer cancel()

	raw, err := s.parser.ParseReceipt(ctx, in)
	if err != nil {
		return ParseReceiptResponse{}, providerError(err)
	}

	return ParseReceiptResponse{Draft: ok.sanitizeReceipt(raw)}, nil
}

// prepare checks the client's date and builds the parser input together
// with the IDs a draft may reference. The validator has already checked the
// formats of today and timezone.
func (s *service) prepare(ctx context.Context, userID uuid.UUID, text, today, timezone string) (ParseInput, allowed, error) {
	day, err := s.checkToday(today, timezone)
	if err != nil {
		return ParseInput{}, allowed{}, err
	}

	ws, err := s.wallets.ListActive(ctx, userID)
	if err != nil {
		return ParseInput{}, allowed{}, err
	}
	cs, err := s.categories.List(ctx, userID, category.ListFilter{})
	if err != nil {
		return ParseInput{}, allowed{}, err
	}
	aliases, err := s.aliases(ctx, ws)
	if err != nil {
		return ParseInput{}, allowed{}, err
	}

	in := ParseInput{
		Text:       text,
		Today:      day.Format(time.DateOnly),
		Timezone:   timezone,
		Wallets:    make([]WalletRef, 0, len(ws)),
		Categories: make([]CategoryRef, 0, len(cs)),
	}
	ok := allowed{
		wallets:    make(map[uuid.UUID]struct{}, len(ws)),
		categories: make(map[uuid.UUID]category.Type, len(cs)),
		today:      day,
	}
	for _, w := range ws {
		ref := WalletRef{ID: w.ID, Name: w.Name}
		if w.ProviderID != nil {
			ref.Aliases = aliases[*w.ProviderID]
		}
		in.Wallets = append(in.Wallets, ref)
		ok.wallets[w.ID] = struct{}{}
	}
	for _, c := range cs {
		in.Categories = append(in.Categories, CategoryRef{ID: c.ID, Name: c.Name, Type: string(c.Type)})
		ok.categories[c.ID] = c.Type
	}

	return in, ok, nil
}

// checkToday parses the client's local date and rejects one more than a day
// away from the server's date in that timezone, so a wrong phone clock
// cannot push drafts into the future.
func (s *service) checkToday(today, timezone string) (time.Time, error) {
	day, err := time.Parse(time.DateOnly, today)
	if err != nil {
		return time.Time{}, ErrTodayOutOfRange
	}
	loc, err := s.zones.Load(timezone)
	if err != nil {
		return time.Time{}, ErrTodayOutOfRange
	}

	server := period.LocalDate(s.now(), loc)
	if diff := day.Sub(server); diff > 24*time.Hour || diff < -24*time.Hour {
		return time.Time{}, ErrTodayOutOfRange
	}

	return day, nil
}

// aliases maps the active providers of ws to their aliases.
func (s *service) aliases(ctx context.Context, ws []wallet.Wallet) (map[uuid.UUID][]string, error) {
	ids := make([]uuid.UUID, 0, len(ws))
	for _, w := range ws {
		if w.ProviderID != nil {
			ids = append(ids, *w.ProviderID)
		}
	}

	return s.providers.ActiveAliases(ctx, ids)
}

// providerError keeps ErrUnavailable (503) and turns anything else into an
// internal error (500).
func providerError(err error) error {
	if errors.Is(err, ErrUnavailable) {
		return err
	}

	return fmt.Errorf("ai: parse: %w", err)
}
