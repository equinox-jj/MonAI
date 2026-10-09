package database

import (
	"context"

	"gorm.io/gorm"
)

type txKey struct{}

// TxManager runs fn inside one DB transaction carried in ctx. Repositories
// pick it up with Conn, so multi-step operations (e.g. register) commit or
// roll back as a whole.
type TxManager interface {
	WithinTx(ctx context.Context, fn func(ctx context.Context) error) error
}

type txManager struct {
	db *gorm.DB
}

func NewTxManager(db *gorm.DB) TxManager {
	return &txManager{db: db}
}

// WithinTx commits when fn returns nil and rolls back otherwise. A call made
// while ctx already holds a transaction joins it instead of nesting.
func (m *txManager) WithinTx(ctx context.Context, fn func(ctx context.Context) error) error {
	if _, ok := ctx.Value(txKey{}).(*gorm.DB); ok {
		return fn(ctx)
	}
	return m.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		return fn(context.WithValue(ctx, txKey{}, tx))
	})
}

// Conn returns the transaction stored in ctx by WithinTx, or db bound to ctx.
func Conn(ctx context.Context, db *gorm.DB) *gorm.DB {
	if tx, ok := ctx.Value(txKey{}).(*gorm.DB); ok {
		return tx
	}
	return db.WithContext(ctx)
}
