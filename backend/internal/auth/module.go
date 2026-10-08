package auth

import "go.uber.org/fx"

var Module = fx.Module("auth",
	fx.Provide(NewRepository, NewService, NewHandler),
	fx.Invoke(RegisterRoutes),
)
