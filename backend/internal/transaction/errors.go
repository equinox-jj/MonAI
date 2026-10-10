package transaction

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrNotFound = httpx.ErrNotFound

	ErrInvalidCursor = httpx.NewError(
		fiber.StatusBadRequest,
		"invalid_cursor",
		"The cursor is invalid. Request the first page again",
	)

	ErrWalletArchived = httpx.NewError(
		fiber.StatusUnprocessableEntity,
		"wallet_archived",
		"One of this transaction's wallets is archived. Unarchive it first",
	)

	ErrNoFields = httpx.ErrValidationFailed.WithMessage("At least one field is required")

	ErrMonthInvalid = fieldError("month", "invalid_format", "must be YYYY-MM")
	ErrDateInvalid  = fieldError("date", "invalid_format", "must be YYYY-MM-DD")
	ErrDateInFuture = fieldError("date", "future_date", "must not be in the future")

	ErrWalletInvalid   = fieldError("wallet_id", "invalid", "must be one of your wallets")
	ErrWalletArchive   = fieldError("wallet_id", "archived", "must not be an archived wallet")
	ErrToWalletNeeded  = fieldError("to_wallet_id", "required", "is required for TRANSFER")
	ErrToWalletBanned  = fieldError("to_wallet_id", "not_allowed", "must be null for EXPENSE and INCOME")
	ErrToWalletSame    = fieldError("to_wallet_id", "not_equal", "must be different from wallet_id")
	ErrToWalletInvalid = fieldError("to_wallet_id", "invalid", "must be one of your wallets")
	ErrToWalletArchive = fieldError("to_wallet_id", "archived", "must not be an archived wallet")

	ErrCategoryNeeded  = fieldError("category_id", "required", "is required for EXPENSE and INCOME")
	ErrCategoryBanned  = fieldError("category_id", "not_allowed", "must be null for TRANSFER")
	ErrCategoryInvalid = fieldError("category_id", "invalid", "must be one of your categories of the same type")

	ErrReceiptKeyInvalid = fieldError("receipt_key", "invalid", "must be a key returned by POST /transactions/receipt")
	ErrReceiptNotFound   = fieldError("receipt_key", "not_found", "no uploaded receipt was found for this key")
)

func fieldError(field, code, message string) *httpx.Error {
	return httpx.ErrValidationFailed.WithFields(httpx.FieldError{
		Field:   field,
		Code:    code,
		Message: message,
	})
}
