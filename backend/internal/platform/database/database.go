package database

import (
	"context"
	"log"
	"os"
	"time"

	"go.uber.org/fx"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
)

// New opens the PostgreSQL connection and closes it when the app stops.
func New(lc fx.Lifecycle, cfg config.Config) (*gorm.DB, error) {
	db, err := gorm.Open(
		postgres.Open(cfg.Postgres.DatabaseURL),
		&gorm.Config{
			Logger: newLogger(),
		},
	)
	if err != nil {
		return nil, err
	}

	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	lc.Append(fx.Hook{
		OnStop: func(context.Context) error { return sqlDB.Close() },
	})

	return db, nil
}

// newLogger matches GORM's default logger but skips ErrRecordNotFound, which
// repositories map to domain not-found errors and is not a failure.
func newLogger() logger.Interface {
	return logger.New(log.New(os.Stdout, "\r\n", log.LstdFlags), logger.Config{
		SlowThreshold:             200 * time.Millisecond,
		LogLevel:                  logger.Warn,
		IgnoreRecordNotFoundError: true,
		Colorful:                  true,
	})
}
