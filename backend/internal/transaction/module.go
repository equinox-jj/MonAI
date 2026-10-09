package transaction

import "go.uber.org/fx"

var Module = fx.Module(
	"transaction",
	fx.Provide(
		NewRepository,
		NewService,
		NewHandler,
	),
	fx.Invoke(RegisterRoutes),
)
