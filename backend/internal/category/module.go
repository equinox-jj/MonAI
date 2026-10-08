package category

import "go.uber.org/fx"

var Module = fx.Module(
	"category",
	fx.Provide(
		NewRepository,
		NewService,
		NewHandler,
	),
	fx.Invoke(RegisterRoutes),
)
