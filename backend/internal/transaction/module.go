package transaction

import (
	"context"

	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/user"
	"github.com/equinox-jj/MonAI/backend/internal/wallet"
)

// Providers builds the feature without registering routes, so cmd tools can
// reuse it; fx only constructs what something asks for.
var Providers = fx.Provide(
	NewRepository,
	NewService,
	NewController,
	NewReceiptCleaner,
	func(r wallet.Repository) Wallets { return r },
	func(r category.Repository) Categories { return r },
	func(r user.Repository) Timezones { return r },
)

var Module = fx.Module(
	"transaction",
	Providers,
	fx.Invoke(RegisterRoutes, startReceiptCleanup),
)

// startReceiptCleanup runs the cleaner in the background while the app runs
// and waits for the current run to stop on shutdown.
func startReceiptCleanup(lc fx.Lifecycle, c *ReceiptCleaner) {
	ctx, cancel := context.WithCancel(context.Background())
	done := make(chan struct{})
	lc.Append(fx.Hook{
		OnStart: func(context.Context) error {
			go func() {
				defer close(done)
				c.RunEvery(ctx, ReceiptCleanupInterval)
			}()
			return nil
		},
		OnStop: func(stopCtx context.Context) error {
			cancel()
			select {
			case <-done:
				return nil
			case <-stopCtx.Done():
				return stopCtx.Err()
			}
		},
	})
}
