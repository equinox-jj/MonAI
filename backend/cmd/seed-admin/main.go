// Command seed-admin promotes an existing user to the admin role. Nobody can
// register as admin, so this is how the first admin is created.
//
// Usage: seed-admin --email you@example.com
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"os"

	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/logger"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
	"github.com/equinox-jj/MonAI/backend/internal/user"
)

func main() {
	email := flag.String("email", "", "email of the user to promote (required)")
	flag.Parse()
	if *email == "" {
		flag.Usage()
		os.Exit(2)
	}

	// Feature modules register HTTP routes, so only the needed constructors
	// are provided here.
	var p *promoter
	app := fx.New(
		fx.NopLogger,
		config.Module,
		logger.Module,
		database.Module,
		rbac.Module,
		fx.Provide(user.NewRepository, newPromoter),
		fx.Populate(&p),
	)
	if err := app.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "seed-admin: setup failed:", err)
		os.Exit(1)
	}

	ctx := context.Background()
	if err := app.Start(ctx); err != nil {
		p.log.Error("seed-admin: start failed", "error", err)
		os.Exit(1)
	}

	runErr := p.promote(ctx, *email)
	if err := errors.Join(runErr, app.Stop(ctx)); err != nil {
		p.log.Error("seed-admin: failed", "error", err)
		os.Exit(1)
	}
}
