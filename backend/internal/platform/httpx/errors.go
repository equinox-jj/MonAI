package httpx

import (
	"github.com/gofiber/fiber/v3"
)

// Error is an API error with its HTTP status and stable machine-readable code.
// Features declare their sentinels with NewError in errors.go, and services
// return them (wrapped with %w or not); ErrorHandler turns them into responses.
type Error struct {
	Status  int
	Code    string
	Message string // English fallback; clients localise from Code
	Fields  []FieldError
}

// NewError declares an API error, e.g.
//
//	var ErrHasTransactions = httpx.NewError(fiber.StatusUnprocessableEntity,
//		"wallet_has_transactions", "This wallet has transactions. Archive it instead")
func NewError(status int, code, message string) *Error {
	return &Error{Status: status, Code: code, Message: message}
}

func (e *Error) Error() string {
	return e.Code + ": " + e.Message
}

// Is matches by status and code, so copies made by WithFields/WithMessage
// still satisfy errors.Is(err, sentinel).
func (e *Error) Is(target error) bool {
	t, ok := target.(*Error)
	return ok && t.Status == e.Status && t.Code == e.Code
}

// WithFields returns a copy of e carrying field details (validation, conflict).
// The sentinel itself is never modified.
func (e *Error) WithFields(fields ...FieldError) *Error {
	c := *e
	c.Fields = fields
	return &c
}

// WithMessage returns a copy of e with a more specific message.
func (e *Error) WithMessage(message string) *Error {
	c := *e
	c.Message = message
	return &c
}

// Shared errors, one per generic error code in the API spec.
var (
	ErrInvalidRequest   = NewError(fiber.StatusBadRequest, "invalid_request", "The request body is not valid JSON")
	ErrUnauthorized     = NewError(fiber.StatusUnauthorized, "unauthorized", "Authentication required")
	ErrForbidden        = NewError(fiber.StatusForbidden, "forbidden", "You do not have permission to perform this action")
	ErrNotFound         = NewError(fiber.StatusNotFound, "not_found", "Resource not found")
	ErrConflict         = NewError(fiber.StatusConflict, "conflict", "This resource already exists")
	ErrValidationFailed = NewError(fiber.StatusUnprocessableEntity, "validation_failed", "Some fields are invalid")
	ErrRateLimited      = NewError(fiber.StatusTooManyRequests, "rate_limited", "Too many requests. Please try again later")
	ErrInternal         = NewError(fiber.StatusInternalServerError, "internal_error", "Something went wrong")
)
