package transaction

import (
	"context"

	"go.uber.org/fx"
)

var Module = fx.Module(
	"transaction",
	fx.Provide(
		NewRepository,
		NewService,
		NewHandler,
		NewReceiptCleaner,
	),
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
