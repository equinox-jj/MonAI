package httpx

import (
	"errors"
	"log/slog"
	"net/http"
	"strings"

	"github.com/gofiber/fiber/v3"
)

// errorResponse is the spec's ErrorResponse envelope.
type errorResponse struct {
	Success bool        `json:"success"`
	Message string      `json:"message"`
	Data    any         `json:"data"`
	Error   errorDetail `json:"error"`
}

type errorDetail struct {
	Code   string       `json:"code"`
	Fields []FieldError `json:"fields,omitempty"`
}

// NewErrorHandler returns the app-wide Fiber error handler. Whatever a handler
// or middleware returns ends up here and is written in the error envelope:
//
//   - *ValidationError (from c.Bind())   → 422 validation_failed with fields
//   - *Error (sentinels, wrapped or not) → its own status, code and message
//   - *fiber.BindError (malformed body)  → 400 invalid_request
//   - *fiber.Error (404 route, 405, …)   → its status with a generic code
//   - anything else                      → logged, 500 internal_error
func NewErrorHandler(log *slog.Logger) fiber.ErrorHandler {
	return func(c fiber.Ctx, err error) error {
		e := toError(err)
		if e.Status >= fiber.StatusInternalServerError {
			// Never log the body: it may hold passwords or financial data.
			log.Error("request failed",
				"method", c.Method(),
				"path", c.Path(),
				"status", e.Status,
				"error", err,
			)
		}

		return c.Status(e.Status).JSON(errorResponse{
			Success: false,
			Message: e.Message,
			Data:    nil,
			Error:   errorDetail{Code: e.Code, Fields: e.Fields},
		})
	}
}

func toError(err error) *Error {
	var verr *ValidationError
	if errors.As(err, &verr) {
		return ErrValidationFailed.WithFields(verr.Fields...)
	}

	var apiErr *Error
	if errors.As(err, &apiErr) {
		return apiErr
	}

	var bindErr *fiber.BindError
	if errors.As(err, &bindErr) {
		return ErrInvalidRequest
	}

	var fiberErr *fiber.Error
	if errors.As(err, &fiberErr) {
		return fromFiberError(fiberErr)
	}

	return ErrInternal
}

// fromFiberError maps errors raised by Fiber itself to the spec's codes.
func fromFiberError(fe *fiber.Error) *Error {
	switch fe.Code {
	case fiber.StatusBadRequest:
		return ErrInvalidRequest
	case fiber.StatusUnprocessableEntity:
		// c.Bind().Body() returns this when the Content-Type is unsupported.
		return ErrInvalidRequest.WithMessage("Content-Type must be application/json")
	case fiber.StatusUnauthorized:
		return ErrUnauthorized
	case fiber.StatusForbidden:
		return ErrForbidden
	case fiber.StatusNotFound:
		return ErrNotFound
	case fiber.StatusTooManyRequests:
		return ErrRateLimited
	}

	if fe.Code >= fiber.StatusInternalServerError {
		return ErrInternal
	}

	// Other 4xx (405, 413, …): "Method Not Allowed" → method_not_allowed.
	text := http.StatusText(fe.Code)
	return NewError(fe.Code, strings.ToLower(strings.ReplaceAll(text, " ", "_")), text)
}
