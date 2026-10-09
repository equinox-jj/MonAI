package httpx

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"
)

// ParamUUID parses the path parameter name as a UUID. A malformed ID cannot
// match any record, so it returns ErrNotFound like a missing one.
func ParamUUID(c fiber.Ctx, name string) (uuid.UUID, error) {
	id, err := uuid.Parse(c.Params(name))
	if err != nil {
		return uuid.Nil, ErrNotFound
	}

	return id, nil
}
