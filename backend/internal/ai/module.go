package ai

import "go.uber.org/fx"

var Module = fx.Module("ai",
	fx.Provide(NewService, NewHandler),
	fx.Invoke(RegisterRoutes),
)
