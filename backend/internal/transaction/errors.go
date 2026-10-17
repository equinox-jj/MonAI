package transaction

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

var (
	ErrNotFound      = httpx.ErrNotFound
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
	ErrMonthInvalid      = httpx.InvalidField("month", "invalid_format", "must be YYYY-MM")
	ErrDateInvalid       = httpx.InvalidField("date", "invalid_format", "must be YYYY-MM-DD")
	ErrDateInFuture      = httpx.InvalidField("date", "future_date", "must not be in the future")
	ErrWalletInvalid     = httpx.InvalidField("wallet_id", "invalid", "must be one of your wallets")
	ErrWalletArchive     = httpx.InvalidField("wallet_id", "archived", "must not be an archived wallet")
	ErrToWalletNeeded    = httpx.InvalidField("to_wallet_id", "required", "is required for TRANSFER")
	ErrToWalletBanned    = httpx.InvalidField("to_wallet_id", "not_allowed", "must be null for EXPENSE and INCOME")
	ErrToWalletSame      = httpx.InvalidField("to_wallet_id", "not_equal", "must be different from wallet_id")
	ErrToWalletInvalid   = httpx.InvalidField("to_wallet_id", "invalid", "must be one of your wallets")
	ErrToWalletArchive   = httpx.InvalidField("to_wallet_id", "archived", "must not be an archived wallet")
	ErrCategoryNeeded    = httpx.InvalidField("category_id", "required", "is required for EXPENSE and INCOME")
	ErrCategoryBanned    = httpx.InvalidField("category_id", "not_allowed", "must be null for TRANSFER")
	ErrCategoryInvalid   = httpx.InvalidField("category_id", "invalid", "must be one of your categories of the same type")
	ErrReceiptKeyInvalid = httpx.InvalidField("receipt_key", "invalid", "must be a key returned by POST /transactions/receipt")
	ErrReceiptNotFound   = httpx.InvalidField("receipt_key", "not_found", "no uploaded receipt was found for this key")
)
