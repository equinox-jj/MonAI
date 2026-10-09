// Package migrations embeds the versioned SQL files applied by cmd/migrate.
package migrations

import "embed"

//go:embed *.sql
var FS embed.FS
