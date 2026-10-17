package budget

import "go.uber.org/fx"

// Providers builds the feature without registering routes, so cmd tools can
// reuse it; fx only constructs what something asks for.
var Providers = fx.Provide(
	NewRepository,
	NewService,
	NewController,
)

var Module = fx.Module(
	"budget",
	Providers,
	fx.Invoke(RegisterRoutes),
)
