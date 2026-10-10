package user

import (
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var Module = fx.Module(
	"user",
	fx.Provide(
		NewRepository,
		NewService,
		NewHandler,
		// RequireAuth checks token versions against the users table.
		func(r Repository) httpx.TokenVersions { return r },
	),
	fx.Invoke(RegisterRoutes),
)
