package gemini

import "go.uber.org/fx"

// Module provides ai.TransactionParser. Swap it in cmd/api to change provider.
var Module = fx.Module("gemini",
	fx.Provide(New),
)
