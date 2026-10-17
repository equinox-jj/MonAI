package health

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"
)

const (
	statusOK   = "ok"
	statusDown = "down"

	pingTimeout = 2 * time.Second
)

type (
	// Database is satisfied by *sql.DB.
	Database interface {
		PingContext(ctx context.Context) error
	}

	// Storage is satisfied by storage.Storage.
	Storage interface {
		Ping(ctx context.Context) error
	}
)

type Service interface {
	// Check pings every dependency concurrently. It returns ErrUnavailable,
	// wrapping the causes, when any of them is down.
	Check(ctx context.Context) (HealthResponse, error)
}

type service struct {
	db    Database
	store Storage
}

func NewService(db Database, store Storage) Service {
	return &service{db: db, store: store}
}

func (s *service) Check(ctx context.Context) (HealthResponse, error) {
	var dbErr, storeErr error
	var wg sync.WaitGroup
	wg.Go(func() { dbErr = ping(ctx, s.db.PingContext) })
	wg.Go(func() { storeErr = ping(ctx, s.store.Ping) })
	wg.Wait()

	resp := HealthResponse{Status: statusOK, Database: status(dbErr), Storage: status(storeErr)}
	if dbErr == nil && storeErr == nil {
		return resp, nil
	}

	var down []string
	if dbErr != nil {
		down = append(down, "database")
	}
	if storeErr != nil {
		down = append(down, "storage")
	}
	resp.Status = statusDown
	msg := "Unavailable: " + strings.Join(down, ", ")
	return resp, fmt.Errorf("health: %w: %w", ErrUnavailable.WithMessage(msg), errors.Join(dbErr, storeErr))
}

func ping(ctx context.Context, fn func(context.Context) error) error {
	ctx, cancel := context.WithTimeout(ctx, pingTimeout)
	defer cancel()
	return fn(ctx)
}

func status(err error) string {
	if err != nil {
		return statusDown
	}
	return statusOK
}
