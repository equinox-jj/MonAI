package logger

import (
	"log/slog"
	"os"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
)

// New returns a JSON logger in production and a text logger elsewhere.
func New(cfg config.Config) *slog.Logger {
	if cfg.App.Env == "production" {
		return slog.New(slog.NewJSONHandler(
			os.Stdout,
			&slog.HandlerOptions{Level: slog.LevelInfo},
		))
	}

	return slog.New(slog.NewTextHandler(
		os.Stdout,
		&slog.HandlerOptions{Level: slog.LevelDebug},
	))
}
