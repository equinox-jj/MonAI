package database

import (
	"errors"
	"strings"

	"github.com/jackc/pgx/v5/pgconn"
	"gorm.io/gorm"
)

// NotFound returns notFound (a feature's ErrNotFound) when err is
// gorm.ErrRecordNotFound, and err otherwise.
func NotFound(err, notFound error) error {
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return notFound
	}

	return err
}

var likeEscaper = strings.NewReplacer(`\`, `\\`, `%`, `\%`, `_`, `\_`)

// EscapeLike escapes LIKE wildcards with PostgreSQL's default escape
// character, so user input matches literally inside a pattern.
func EscapeLike(s string) string {
	return likeEscaper.Replace(s)
}

const (
	pgUniqueViolation     = "23505"
	pgForeignKeyViolation = "23503"
)

// IsUniqueViolation reports whether err is a PostgreSQL unique violation on the
// named constraint or unique index.
func IsUniqueViolation(err error, constraint string) bool {
	return isViolation(err, pgUniqueViolation, constraint)
}

// IsForeignKeyViolation reports whether err is a PostgreSQL foreign key
// violation on the named constraint.
func IsForeignKeyViolation(err error, constraint string) bool {
	return isViolation(err, pgForeignKeyViolation, constraint)
}

func isViolation(err error, code, constraint string) bool {
	var pgErr *pgconn.PgError
	return errors.As(err, &pgErr) && pgErr.Code == code && pgErr.ConstraintName == constraint
}
