package user

import (
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
)

// Providers builds the feature without registering routes, so cmd tools can
// reuse it; fx only constructs what something asks for.
var Providers = fx.Provide(
	NewRepository,
	NewService,
	NewController,
	// RequireAuth checks token versions against the users table.
	func(r Repository) httpx.TokenVersions { return r },
	func(s rbac.Service) Roles { return s },
)

var Module = fx.Module(
	"user",
	Providers,
	fx.Invoke(RegisterRoutes),
)
