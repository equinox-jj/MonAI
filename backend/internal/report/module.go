package report

import "go.uber.org/fx"

var Module = fx.Module("report",
	fx.Provide(NewRepository, NewService, NewHandler),
	fx.Invoke(RegisterRoutes),
)
