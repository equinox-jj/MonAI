package wallet

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrNotFound  = httpx.ErrNotFound
	ErrNameTaken = httpx.ErrConflict.WithMessage("Wallet name already exists")
	// ErrDefaultRace is a concurrent request making another wallet the default.
	ErrDefaultRace     = httpx.ErrConflict.WithMessage("Another wallet was set as default at the same time. Try again")
	ErrDefaultRequired = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"default_wallet_required",
		"A default wallet is required. Set another wallet as default first",
	)
	ErrArchiveDefault  = ErrDefaultRequired.WithMessage("The default wallet cannot be archived")
	ErrDeleteDefault   = ErrDefaultRequired.WithMessage("The default wallet cannot be deleted")
	ErrHasTransactions = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"wallet_has_transactions",
		"This wallet has transactions. Archive it instead",
	)
	ErrArchived = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"wallet_archived",
		"An archived wallet cannot be the default. Unarchive it first",
	)
	ErrNameBlank = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "name",
		Code:    "required",
		Message: "must not be blank",
	})
	ErrTypeRequired = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "type",
		Code:    "required",
		Message: "is required when provider_id is null",
	})
	ErrProviderInvalid = httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   "provider_id",
		Code:    "invalid",
		Message: "must be an active payment provider",
	})
)
