package httpx

import (
	"context"
	"log/slog"
	"net"
	"runtime/debug"
	"time"

	"github.com/gofiber/fiber/v3"
	"github.com/gofiber/fiber/v3/middleware/helmet"
	"github.com/gofiber/fiber/v3/middleware/recover"
	"github.com/gofiber/fiber/v3/middleware/requestid"
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
)

// bodyLimit caps request bodies. It is just above the largest upload (5 MB
// receipts) to leave room for the multipart framing.
const bodyLimit = 6 << 20

// Connection timeouts. Without them a client can hold a connection open by
// sending its request slowly (slowloris).
const (
	readTimeout  = 10 * time.Second
	writeTimeout = 30 * time.Second
	idleTimeout  = 60 * time.Second
)

// NewApp creates the Fiber app. c.Bind() runs v on every decoded request, and
// every error returned by a handler or middleware is written by NewErrorHandler.
// Every request gets an X-Request-ID, security headers, and panic recovery.
func NewApp(v *Validator, log *slog.Logger, cfg config.Config) *fiber.App {
	fc := fiber.Config{
		AppName:         "MonAI API",
		StructValidator: v,
		BodyLimit:       bodyLimit,
		ReadTimeout:     readTimeout,
		WriteTimeout:    writeTimeout,
		IdleTimeout:     idleTimeout,
		ErrorHandler:    NewErrorHandler(log),
	}
	// c.IP() (and so ByIP) reads X-Forwarded-For only from trusted proxies;
	// otherwise any client could pick its own rate-limit key.
	if len(cfg.App.TrustedProxies) > 0 {
		fc.TrustProxy = true
		fc.TrustProxyConfig = fiber.TrustProxyConfig{Proxies: cfg.App.TrustedProxies}
		fc.ProxyHeader = fiber.HeaderXForwardedFor
		fc.EnableIPValidation = true
	}

	app := fiber.New(fc)
	app.Use(
		requestid.New(),
		recover.New(recover.Config{
			EnableStackTrace: true,
			StackTraceHandler: func(c fiber.Ctx, e any) {
				log.Error("panic recovered",
					"request_id", requestid.FromContext(c),
					"method", c.Method(),
					"path", c.Path(),
					"panic", e,
					"stack", string(debug.Stack()),
				)
			},
		}),
		helmet.New(),
	)

	return app
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
