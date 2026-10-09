package auth

import "go.uber.org/fx"

var Module = fx.Module(
	"auth",
	fx.Provide(
		NewService,
		NewHandler,
	),
	fx.Invoke(RegisterRoutes),
)
