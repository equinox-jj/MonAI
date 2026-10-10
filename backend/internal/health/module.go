package health

import (
	"go.uber.org/fx"
	"gorm.io/gorm"

	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
)

var Module = fx.Module(
	"health",
	fx.Provide(
		func(db *gorm.DB) (Database, error) { return db.DB() },
		func(store storage.Storage) Storage { return store },
		NewService,
		NewHandler,
	),
	fx.Invoke(RegisterRoutes),
)
