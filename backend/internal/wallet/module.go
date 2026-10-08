package wallet

import "go.uber.org/fx"

var Module = fx.Module("wallet",
	fx.Provide(NewRepository, NewService, NewHandler),
	fx.Invoke(RegisterRoutes),
)
