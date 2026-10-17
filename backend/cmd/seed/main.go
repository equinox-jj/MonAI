// Command seed creates a demo user with wallets and a few months of
// transactions for local development. Roles, permissions and payment
// providers are seeded by the migrations, not here.
//
// Usage: seed [--email E] [--password P] [--name N] [--months M]
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"os"

	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/auth"
	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/logger"
	"github.com/equinox-jj/MonAI/backend/internal/platform/security"
	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
	"github.com/equinox-jj/MonAI/backend/internal/provider"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
	"github.com/equinox-jj/MonAI/backend/internal/transaction"
	"github.com/equinox-jj/MonAI/backend/internal/user"
	"github.com/equinox-jj/MonAI/backend/internal/wallet"
)

func main() {
	var opts options
	flag.StringVar(&opts.email, "email", "demo@monai.local", "demo user email")
	flag.StringVar(&opts.password, "password", "demo12345", "demo user password (8-72 characters)")
	flag.StringVar(&opts.name, "name", "Demo User", "demo user name")
	flag.IntVar(&opts.months, "months", 3, "months of transactions, including the current one")
	flag.Parse()
	if opts.months < 1 || len(opts.password) < 8 || len(opts.password) > 72 {
		flag.Usage()
		os.Exit(2)
	}

	// Check the environment before fx connects to anything.
	cfg, err := config.Load()
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	if cfg.App.Env == "production" {
		fmt.Fprintln(os.Stderr, "seed: refusing to create demo data in production")
		os.Exit(1)
	}

	// Feature Modules register HTTP routes, so only their Providers are used.
	var s *seeder
	app := fx.New(
		fx.NopLogger,
		fx.Supply(cfg),
		logger.Module,
		database.Module,
		security.Module,
		storage.Module,
		rbac.Module,
		user.Providers,
		wallet.Providers,
		category.Providers,
		transaction.Providers,
		provider.Providers,
		auth.Providers,
		fx.Provide(newSeeder),
		fx.Populate(&s),
	)
	if err := app.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "seed: setup failed:", err)
		os.Exit(1)
	}

	ctx := context.Background()
	if err := app.Start(ctx); err != nil {
		s.log.Error("seed: start failed", "error", err)
		os.Exit(1)
	}

	runErr := s.run(ctx, opts)
	if err := errors.Join(runErr, app.Stop(ctx)); err != nil {
		s.log.Error("seed: failed", "error", err)
		os.Exit(1)
	}
}
