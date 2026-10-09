package wallet

import "github.com/equinox-jj/MonAI/backend/internal/platform/httpx"

var (
	ErrNotFound  = httpx.ErrNotFound
	ErrNameTaken = httpx.ErrConflict.WithMessage("Wallet name already exists")
)
