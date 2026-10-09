package security

import "go.uber.org/fx"

var Module = fx.Module(
	"security",
	fx.Provide(
		NewJWTManager,
		NewPasswordHasher,
	),
)
