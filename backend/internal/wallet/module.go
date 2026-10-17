package wallet

import (
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/provider"
)

// Providers builds the feature without registering routes, so cmd tools can
// reuse it; fx only constructs what something asks for.
var Providers = fx.Provide(
	NewRepository,
	NewService,
	NewController,
	func(r provider.Repository) PaymentProviders { return r },
)

var Module = fx.Module(
	"wallet",
	Providers,
	fx.Invoke(RegisterRoutes),
)
