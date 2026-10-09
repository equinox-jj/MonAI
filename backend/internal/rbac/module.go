package rbac

import "go.uber.org/fx"

var Module = fx.Module("rbac",
	fx.Provide(NewRepository, NewService),
)
