// Command migrate applies the SQL migrations embedded from migrations/.
//
// Usage: migrate [up | down [N] | version | force V]
package main

import (
	"database/sql"
	"errors"
	"fmt"
	"log/slog"
	"os"
	"strconv"

	"github.com/golang-migrate/migrate/v4"
	pgxv5 "github.com/golang-migrate/migrate/v4/database/pgx/v5"
	"github.com/golang-migrate/migrate/v4/source/iofs"
	_ "github.com/jackc/pgx/v5/stdlib"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/logger"
	"github.com/equinox-jj/MonAI/backend/migrations"
)

const usage = "usage: migrate [up | down [N] | version | force V]"

func main() {
	cfg, err := config.Load()
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	log := logger.New(cfg)

	m, err := newMigrate(cfg.Postgres.DatabaseURL)
	if err != nil {
		log.Error("migrate: setup failed", "error", err)
		os.Exit(1)
	}

	runErr := run(os.Args[1:], m, log)
	srcErr, dbErr := m.Close()
	if err := errors.Join(runErr, srcErr, dbErr); err != nil {
		log.Error("migrate: failed", "error", err)
		os.Exit(1)
	}
}

// newMigrate wires the embedded SQL files to the database. It opens the
// connection through pgx's database/sql driver so the postgres:// URL from
// config works as is.
func newMigrate(databaseURL string) (*migrate.Migrate, error) {
	db, err := sql.Open("pgx", databaseURL)
	if err != nil {
		return nil, err
	}

	drv, err := pgxv5.WithInstance(db, &pgxv5.Config{})
	if err != nil {
		_ = db.Close()
		return nil, err
	}

	src, err := iofs.New(migrations.FS, ".")
	if err != nil {
		_ = db.Close()
		return nil, err
	}

	return migrate.NewWithInstance("iofs", src, "pgx5", drv)
}

// run executes one subcommand. Up is the default; down rolls back one step
// unless N is given, so a bare "down" never drops the whole schema.
func run(args []string, m *migrate.Migrate, log *slog.Logger) error {
	cmd := "up"
	if len(args) > 0 {
		cmd = args[0]
	}

	var err error
	switch cmd {
	case "up":
		err = m.Up()
	case "down":
		n := 1
		if len(args) > 1 {
			if n, err = positiveInt(args[1]); err != nil {
				return err
			}
		}
		err = m.Steps(-n)
	case "force":
		if len(args) < 2 {
			return errors.New(usage)
		}
		v, convErr := strconv.Atoi(args[1])
		if convErr != nil {
			return fmt.Errorf("invalid version %q", args[1])
		}
		err = m.Force(v)
	case "version":
		// Reported below.
	default:
		return errors.New(usage)
	}

	if errors.Is(err, migrate.ErrNoChange) {
		log.Info("migrate: no change")
	} else if err != nil {
		return err
	}

	return logVersion(m, log)
}

func logVersion(m *migrate.Migrate, log *slog.Logger) error {
	v, dirty, err := m.Version()
	if errors.Is(err, migrate.ErrNilVersion) {
		log.Info("migrate: no migrations applied")
		return nil
	}
	if err != nil {
		return err
	}
	log.Info("migrate: current version", "version", v, "dirty", dirty)
	return nil
}

func positiveInt(s string) (int, error) {
	n, err := strconv.Atoi(s)
	if err != nil || n < 1 {
		return 0, fmt.Errorf("invalid step count %q: must be a positive integer", s)
	}
	return n, nil
}
