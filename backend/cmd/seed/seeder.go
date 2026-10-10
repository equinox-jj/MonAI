package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"math/rand/v2"
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/auth"
	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/provider"
	"github.com/equinox-jj/MonAI/backend/internal/transaction"
	"github.com/equinox-jj/MonAI/backend/internal/user"
	"github.com/equinox-jj/MonAI/backend/internal/wallet"
)

const dateLayout = "2006-01-02"

// jakarta matches the transaction service's fixed user zone, so no seeded
// date is in the future for it.
var jakarta = time.FixedZone("Asia/Jakarta", 7*60*60)

// Wallet keys used by the tables below. The Cash wallet comes from register.
const (
	walletCash  = "cash"
	walletBCA   = "bca"
	walletGoPay = "gopay"
)

// extraWallets are created from providers after register.
var extraWallets = []struct {
	key            string // also the provider slug
	initialBalance int64
}{
	{walletBCA, 5_000_000},
	{walletGoPay, 200_000},
}

// expenseSpec describes one kind of daily expense. Weight sets how often it
// is picked; amounts are rounded down to Rp 500.
type expenseSpec struct {
	category  string
	weight    int
	min, max  int64
	wallets   []string
	merchants []string
}

var dailyExpenses = []expenseSpec{
	{"Food", 10, 15_000, 75_000, []string{walletCash, walletGoPay}, []string{"Warteg Bahari", "Kopi Kenangan", "Bakso Pak Kumis", "GoFood"}},
	{"Transport", 6, 10_000, 50_000, []string{walletGoPay, walletCash}, []string{"Gojek", "Grab", "KRL Commuter", "Pertamina"}},
	{"Shopping", 2, 50_000, 400_000, []string{walletBCA, walletGoPay}, []string{"Tokopedia", "Shopee", "Indomaret", "Alfamart"}},
	{"Health", 1, 25_000, 250_000, []string{walletBCA, walletCash}, []string{"Kimia Farma", "Guardian"}},
	{"Entertainment", 2, 40_000, 200_000, []string{walletBCA, walletGoPay}, []string{"CGV", "Netflix", "Spotify"}},
}

var billMerchants = []string{"PLN", "Telkomsel", "IndiHome", "PDAM"}

type options struct {
	email, password, name string
	months                int
}

// seeder creates a demo user through the real services, so every business
// rule that applies to API clients also applies to the seeded data.
type seeder struct {
	auth         auth.Service
	wallets      wallet.Service
	categories   category.Service
	transactions transaction.Service
	providers    provider.Repository
	users        user.Repository
	tx           database.TxManager
	log          *slog.Logger
	now          func() time.Time
}

func newSeeder(
	authSvc auth.Service,
	wallets wallet.Service,
	categories category.Service,
	transactions transaction.Service,
	providers provider.Repository,
	users user.Repository,
	tx database.TxManager,
	log *slog.Logger,
) *seeder {
	return &seeder{
		auth:         authSvc,
		wallets:      wallets,
		categories:   categories,
		transactions: transactions,
		providers:    providers,
		users:        users,
		tx:           tx,
		log:          log,
		now:          time.Now,
	}
}

// run creates the demo user, wallets and transactions in one DB transaction.
// It does nothing when the email is already registered.
func (s *seeder) run(ctx context.Context, opts options) error {
	_, err := s.users.FindByEmail(ctx, opts.email)
	if err == nil {
		s.log.Info("seed: demo user already exists; delete the account to reseed", "email", opts.email)
		return nil
	}
	if !errors.Is(err, user.ErrNotFound) {
		return err
	}

	var created int
	err = s.tx.WithinTx(ctx, func(ctx context.Context) error {
		resp, err := s.auth.Register(ctx, auth.RegisterRequest{
			Name:     opts.name,
			Email:    opts.email,
			Password: opts.password,
		})
		if err != nil {
			return fmt.Errorf("register: %w", err)
		}
		userID := resp.User.ID

		wallets, err := s.createWallets(ctx, userID)
		if err != nil {
			return err
		}
		categories, err := s.categoryIDs(ctx, userID)
		if err != nil {
			return err
		}

		created, err = s.createTransactions(ctx, userID, opts.months, wallets, categories)
		return err
	})
	if err != nil {
		return err
	}

	s.log.Info("seed: demo data created",
		"email", opts.email,
		"wallets", len(extraWallets)+1,
		"transactions", created,
	)
	return nil
}

// createWallets adds the extra wallets and returns every wallet ID by key.
func (s *seeder) createWallets(ctx context.Context, userID uuid.UUID) (map[string]uuid.UUID, error) {
	existing, _, err := s.wallets.List(ctx, userID, wallet.ListWalletsQuery{})
	if err != nil {
		return nil, err
	}
	ids := map[string]uuid.UUID{}
	for _, w := range existing {
		if w.IsDefault {
			ids[walletCash] = w.ID
		}
	}
	if _, ok := ids[walletCash]; !ok {
		return nil, errors.New("register did not create a default wallet")
	}

	for _, spec := range extraWallets {
		p, err := s.providers.FindBySlug(ctx, spec.key)
		if err != nil {
			return nil, fmt.Errorf("provider %q: %w", spec.key, err)
		}
		w, err := s.wallets.Create(ctx, userID, wallet.CreateWalletRequest{
			ProviderID:     &p.ID,
			InitialBalance: spec.initialBalance,
		})
		if err != nil {
			return nil, fmt.Errorf("wallet %q: %w", spec.key, err)
		}
		ids[spec.key] = w.ID
	}

	return ids, nil
}

// categoryIDs returns the user's category IDs by name.
func (s *seeder) categoryIDs(ctx context.Context, userID uuid.UUID) (map[string]uuid.UUID, error) {
	cs, err := s.categories.List(ctx, userID, category.ListCategoriesQuery{})
	if err != nil {
		return nil, err
	}

	ids := make(map[string]uuid.UUID, len(cs))
	for _, c := range cs {
		ids[c.Name] = c.ID
	}
	return ids, nil
}

// createTransactions fills every day from the first day of the month
// (months-1) months ago up to today, and returns how many it created. A fixed
// random seed makes every run produce the same data.
func (s *seeder) createTransactions(
	ctx context.Context,
	userID uuid.UUID,
	months int,
	wallets, categories map[string]uuid.UUID,
) (int, error) {
	rng := rand.New(rand.NewPCG(1, 2))
	today := dateOnly(s.now().In(jakarta))
	start := time.Date(today.Year(), today.Month()-time.Month(months-1), 1, 0, 0, 0, 0, time.UTC)

	created := 0
	add := func(req transaction.CreateTransactionRequest) error {
		if _, err := s.transactions.Create(ctx, userID, req); err != nil {
			return fmt.Errorf("transaction on %s: %w", req.Date, err)
		}
		created++
		return nil
	}

	for d := start; !d.After(today); d = d.AddDate(0, 0, 1) {
		date := d.Format(dateLayout)
		for _, req := range fixedForDay(d, date, rng, wallets, categories) {
			if err := add(req); err != nil {
				return created, err
			}
		}
		for range 1 + rng.IntN(3) {
			if err := add(randomExpense(date, rng, wallets, categories)); err != nil {
				return created, err
			}
		}
	}

	return created, nil
}

// fixedForDay returns the recurring transactions that fall on d: top-ups at
// the start of the month, bills, and salary on the 25th.
func fixedForDay(
	d time.Time,
	date string,
	rng *rand.Rand,
	wallets, categories map[string]uuid.UUID,
) []transaction.CreateTransactionRequest {
	var reqs []transaction.CreateTransactionRequest
	switch d.Day() {
	case 1:
		reqs = append(reqs,
			transfer(date, 1_000_000, wallets[walletBCA], wallets[walletCash], "ATM withdrawal"),
			transfer(date, 300_000, wallets[walletBCA], wallets[walletGoPay], "GoPay top-up"),
		)
	case 5:
		reqs = append(reqs, transaction.CreateTransactionRequest{
			Type:       transaction.TypeExpense,
			Amount:     roundAmount(450_000 + rng.Int64N(450_001)),
			WalletID:   wallets[walletBCA],
			CategoryID: idPtr(categories["Bills"]),
			Date:       date,
			Merchant:   strPtr(pick(rng, billMerchants)),
		})
	case 15:
		reqs = append(reqs, transfer(date, 300_000, wallets[walletBCA], wallets[walletGoPay], "GoPay top-up"))
	case 25:
		reqs = append(reqs, transaction.CreateTransactionRequest{
			Type:       transaction.TypeIncome,
			Amount:     8_500_000,
			WalletID:   wallets[walletBCA],
			CategoryID: idPtr(categories["Salary"]),
			Date:       date,
			Note:       strPtr("Monthly salary"),
		})
	}
	return reqs
}

func randomExpense(date string, rng *rand.Rand, wallets, categories map[string]uuid.UUID) transaction.CreateTransactionRequest {
	spec := pickWeighted(rng, dailyExpenses)
	req := transaction.CreateTransactionRequest{
		Type:       transaction.TypeExpense,
		Amount:     roundAmount(spec.min + rng.Int64N(spec.max-spec.min+1)),
		WalletID:   wallets[pick(rng, spec.wallets)],
		CategoryID: idPtr(categories[spec.category]),
		Date:       date,
	}
	// Leave some merchants empty, like real manual entries.
	if rng.IntN(4) > 0 {
		req.Merchant = strPtr(pick(rng, spec.merchants))
	}
	return req
}

func transfer(date string, amount int64, from, to uuid.UUID, note string) transaction.CreateTransactionRequest {
	return transaction.CreateTransactionRequest{
		Type:       transaction.TypeTransfer,
		Amount:     amount,
		WalletID:   from,
		ToWalletID: &to,
		Date:       date,
		Note:       &note,
	}
}

func pickWeighted(rng *rand.Rand, specs []expenseSpec) expenseSpec {
	total := 0
	for _, s := range specs {
		total += s.weight
	}
	n := rng.IntN(total)
	for _, s := range specs {
		if n < s.weight {
			return s
		}
		n -= s.weight
	}
	return specs[len(specs)-1]
}

func pick[T any](rng *rand.Rand, xs []T) T { return xs[rng.IntN(len(xs))] }

// roundAmount rounds down to Rp 500, the smallest common price step.
func roundAmount(v int64) int64 { return max(v/500*500, 500) }

func dateOnly(t time.Time) time.Time {
	y, m, d := t.Date()
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
}

func idPtr(id uuid.UUID) *uuid.UUID { return &id }
func strPtr(s string) *string       { return &s }
