package storage

import "go.uber.org/fx"

var Module = fx.Module(
	"storage",
	fx.Provide(New),
)
