package httpx

import "github.com/gofiber/fiber/v3"

// successResponse is the spec's success envelope. meta is added with pagination.
type successResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
	Data    any    `json:"data"`
}

// OK writes a 200 success envelope with data.
func OK(c fiber.Ctx, message string, data any) error {
	return write(c, fiber.StatusOK, message, data)
}

// Created writes a 201 success envelope with data.
func Created(c fiber.Ctx, message string, data any) error {
	return write(c, fiber.StatusCreated, message, data)
}

// Deleted writes the spec's Deleted response: 200 with data null.
func Deleted(c fiber.Ctx) error {
	return OK(c, "Deleted successfully.", nil)
}

func write(c fiber.Ctx, status int, message string, data any) error {
	return c.Status(status).JSON(successResponse{
		Success: true,
		Message: message,
		Data:    data,
	})
}

// metaResponse is the success envelope of an unpaginated list with meta.
type metaResponse struct {
	successResponse
	Meta any `json:"meta"`
}

// OKWithMeta writes a 200 success envelope with data and a non-pagination
// meta (e.g. a list total).
func OKWithMeta(c fiber.Ctx, message string, data, meta any) error {
	return c.Status(fiber.StatusOK).JSON(metaResponse{
		Success: true,
		Message: message,
		Data:    data,
		Meta:    meta,
	})
}

// pagedResponse is the success envelope of an offset-paginated list.
type pagedResponse struct {
	successResponse
	Meta PageMeta `json:"meta"`
}

// Paginated writes a 200 success envelope with data and its page meta.
func Paginated(c fiber.Ctx, message string, data any, meta PageMeta) error {
	return c.Status(fiber.StatusOK).JSON(pagedResponse{
		Success: true,
		Message: message,
		Data:    data,
		Meta:    meta,
	})
}

// cursorResponse is the success envelope of a cursor-paginated list.
type cursorResponse struct {
	successResponse
	Meta CursorMeta `json:"meta"`
}

// CursorPaginated writes a 200 success envelope with data and its cursor meta.
func CursorPaginated(c fiber.Ctx, message string, data any, meta CursorMeta) error {
	return c.Status(fiber.StatusOK).JSON(cursorResponse{
		Success: true,
		Message: message,
		Data:    data,
		Meta:    meta,
	})
}
