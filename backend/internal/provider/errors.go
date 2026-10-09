package provider

import "github.com/equinox-jj/MonAI/backend/internal/platform/httpx"

var (
	ErrNotFound   = httpx.ErrNotFound
	ErrSlugTaken  = httpx.ErrConflict.WithMessage("Provider slug already exists")
	ErrAliasTaken = httpx.ErrConflict.WithMessage("Provider alias already exists")
)
