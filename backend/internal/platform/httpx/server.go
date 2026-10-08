package httpx

import (
	"context"
	"log/slog"
	"net"

	"github.com/gofiber/fiber/v3"
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
)

// NewApp creates the Fiber app.
func NewApp() *fiber.App {
	return fiber.New(fiber.Config{AppName: "MonAI API"})
}

// NewAPIRouter returns the /api/v1 group that feature routes register on.
func NewAPIRouter(app *fiber.App) fiber.Router {
	return app.Group("/api/v1")
}

// startServer binds the port in OnStart so a bind error fails startup,
// then serves in the background and shuts down gracefully in OnStop.
func startServer(lc fx.Lifecycle, app *fiber.App, cfg config.Config, log *slog.Logger) {
	lc.Append(fx.Hook{
		OnStart: func(context.Context) error {
			ln, err := net.Listen("tcp", ":"+cfg.App.Port)
			if err != nil {
				return err
			}
			log.Info("http server listening", "addr", ln.Addr().String())
			go func() {
				if err := app.Listener(ln, fiber.ListenConfig{DisableStartupMessage: true}); err != nil {
					log.Error("http server stopped", "error", err)
				}
			}()
			return nil
		},
		OnStop: func(ctx context.Context) error {
			return app.ShutdownWithContext(ctx)
		},
	})
}
