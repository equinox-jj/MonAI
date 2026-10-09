package user

import "go.uber.org/fx"

var Module = fx.Module(
	"user",
	fx.Provide(
		NewRepository,
		NewService,
		NewHandler,
	),
	fx.Invoke(RegisterRoutes),
)
