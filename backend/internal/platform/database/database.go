package database

import (
	"context"

	"go.uber.org/fx"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
)

// New opens the PostgreSQL connection and closes it when the app stops.
func New(lc fx.Lifecycle, cfg config.Config) (*gorm.DB, error) {
	db, err := gorm.Open(postgres.Open(cfg.Postgres.DatabaseURL), &gorm.Config{})
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
