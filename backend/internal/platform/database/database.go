package database

import (
	"context"
	"log/slog"
	"time"

	"go.uber.org/fx"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
)

// New opens the PostgreSQL connection pool and closes it when the app stops.
func New(lc fx.Lifecycle, cfg config.Config, log *slog.Logger) (*gorm.DB, error) {
	db, err := gorm.Open(
		postgres.Open(cfg.Postgres.DatabaseURL),
		&gorm.Config{
			Logger: newLogger(log),
		},
	)
	if err != nil {
		return nil, err
	}

	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}
	sqlDB.SetMaxOpenConns(cfg.Postgres.MaxOpenConns)
	sqlDB.SetMaxIdleConns(cfg.Postgres.MaxIdleConns)
	sqlDB.SetConnMaxLifetime(cfg.Postgres.ConnMaxLifetime)

	lc.Append(fx.Hook{
		OnStop: func(context.Context) error { return sqlDB.Close() },
	})

	return db, nil
}

// newLogger logs slow and failed queries through slog. It skips
// ErrRecordNotFound, which repositories map to domain not-found errors, and
// logs SQL with placeholders only: bound values hold password hashes, emails
// and financial data.
func newLogger(log *slog.Logger) logger.Interface {
	return logger.NewSlogLogger(log.With("component", "gorm"), logger.Config{
		SlowThreshold:             200 * time.Millisecond,
		LogLevel:                  logger.Warn,
		IgnoreRecordNotFoundError: true,
		ParameterizedQueries:      true,
	})
}
