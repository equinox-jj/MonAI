package ai

import (
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/provider"
	"github.com/equinox-jj/MonAI/backend/internal/wallet"
)

// Providers builds the feature without registering routes, so cmd tools can
// reuse it; fx only constructs what something asks for.
var Providers = fx.Provide(
	NewService,
	NewController,
	func(r wallet.Repository) Wallets { return r },
	func(r category.Repository) Categories { return r },
	func(r provider.Repository) ProviderAliases { return r },
)

var Module = fx.Module(
	"ai",
	Providers,
	fx.Invoke(RegisterRoutes),
)
