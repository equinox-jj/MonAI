package health

import (
	"go.uber.org/fx"
	"gorm.io/gorm"

	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
)

// Providers builds the feature without registering routes, so cmd tools can
// reuse it; fx only constructs what something asks for.
var Providers = fx.Provide(
	func(db *gorm.DB) (Database, error) { return db.DB() },
	func(store storage.Storage) Storage { return store },
	NewService,
	NewController,
)

var Module = fx.Module(
	"health",
	Providers,
	fx.Invoke(RegisterRoutes),
)
