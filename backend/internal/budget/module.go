package budget

import "go.uber.org/fx"

var Module = fx.Module(
	"budget",
	fx.Provide(
		NewRepository,
		NewService,
		NewHandler,
	),
	fx.Invoke(RegisterRoutes),
)
