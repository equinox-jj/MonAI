package httpx

import "go.uber.org/fx"

var Module = fx.Module(
	"httpx",
	fx.Provide(
		NewValidator,
		NewApp,
		NewAPIRouter,
	),
	fx.Invoke(startServer),
)
