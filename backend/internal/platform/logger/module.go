package logger

import (
	"log/slog"

	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"
)

var Module = fx.Module("logger",
	fx.Provide(New),
)

// FxLogger routes fx's own lifecycle logs through slog.
var FxLogger = fx.WithLogger(func(l *slog.Logger) fxevent.Logger {
	return &fxevent.SlogLogger{Logger: l}
})
