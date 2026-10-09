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
	return c.Status(fiber.StatusOK).JSON(successResponse{
		Success: true,
		Message: message,
		Data:    data,
	})
}

// Deleted writes the spec's Deleted response: 200 with data null.
func Deleted(c fiber.Ctx) error {
	return OK(c, "Deleted successfully.", nil)
}
