package transaction

import (
	"context"
	"log/slog"
	"time"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
)

const (
	// ReceiptRetention is how long a deleted transaction keeps its receipt
	// photo, so it can still be restored with it.
	ReceiptRetention = 30 * 24 * time.Hour
	// ReceiptCleanupInterval is how often the API runs the cleanup.
	ReceiptCleanupInterval = time.Hour

	receiptCleanupBatch = 100
)

// ReceiptCleaner deletes the receipt photos of transactions that were
// soft-deleted more than ReceiptRetention ago. A photo shared with a
// transaction that still needs it is kept.
type ReceiptCleaner struct {
	repo   Repository
	tx     database.TxManager
	store  storage.Storage
	log    *slog.Logger
	bucket string // private bucket holding receipts
	now    func() time.Time
}

func NewReceiptCleaner(
	repo Repository,
	tx database.TxManager,
	store storage.Storage,
	log *slog.Logger,
	cfg config.Config,
) *ReceiptCleaner {
	return &ReceiptCleaner{
		repo:   repo,
		tx:     tx,
		store:  store,
		log:    log,
		bucket: cfg.MinIO.BucketPrivate,
		now:    time.Now,
	}
}

// Run removes every expired receipt and returns how many objects it deleted.
// It stops at the first error; the next run retries from there.
func (c *ReceiptCleaner) Run(ctx context.Context) (int, error) {
	cutoff := c.now().Add(-ReceiptRetention).UTC()
	removed := 0
	for {
		keys, err := c.repo.ExpiredReceiptKeys(ctx, cutoff, receiptCleanupBatch)
		if err != nil {
			return removed, err
		}
		for _, key := range keys {
			deleted, err := c.remove(ctx, key, cutoff)
			if err != nil {
				return removed, err
			}
			if deleted {
				removed++
			}
		}
		if len(keys) < receiptCleanupBatch {
			return removed, nil
		}
	}
}

// remove clears key from the expired transactions and deletes the object in
// one DB transaction, so a failed delete rolls the rows back for a retry. It
// reports false when a transaction was restored in between and still uses it.
func (c *ReceiptCleaner) remove(ctx context.Context, key string, cutoff time.Time) (bool, error) {
	deleted := false
	err := c.tx.WithinTx(ctx, func(ctx context.Context) error {
		n, err := c.repo.ClearExpiredReceiptKey(ctx, key, cutoff)
		if err != nil || n == 0 {
			return err
		}
		deleted = true
		return c.store.Delete(ctx, c.bucket, key)
	})

	return deleted && err == nil, err
}

// RunEvery runs the cleanup now and then every interval until ctx is done,
// logging the outcome of each run.
func (c *ReceiptCleaner) RunEvery(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		removed, err := c.Run(ctx)
		switch {
		case err != nil && ctx.Err() == nil:
			c.log.ErrorContext(ctx, "receipt cleanup failed", "removed", removed, "error", err)
		case removed > 0:
			c.log.InfoContext(ctx, "receipt cleanup", "removed", removed)
		}

		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
		}
	}
}
