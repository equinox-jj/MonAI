package auth

import (
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
	"github.com/equinox-jj/MonAI/backend/internal/user"
	"github.com/equinox-jj/MonAI/backend/internal/wallet"
)

// Providers builds the feature without registering routes, so cmd tools can
// reuse it; fx only constructs what something asks for.
var Providers = fx.Provide(
	NewService,
	NewController,
	func(r user.Repository) Users { return r },
	func(s user.Service) Profiles { return s },
	func(s rbac.Service) Roles { return s },
	func(s wallet.Service) WalletSeeder { return s },
	func(s category.Service) CategorySeeder { return s },
)

var Module = fx.Module(
	"auth",
	Providers,
	fx.Invoke(RegisterRoutes),
)
