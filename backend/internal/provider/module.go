package provider

import "go.uber.org/fx"

var Module = fx.Module("provider",
	fx.Provide(NewRepository, NewService, NewHandler),
	fx.Invoke(RegisterRoutes),
)
