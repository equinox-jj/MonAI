package health

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

type Handler interface {
	Check(c fiber.Ctx) error
}

type handler struct {
	svc Service
}

func NewHandler(svc Service) Handler {
	return &handler{svc: svc}
}

func (h *handler) Check(c fiber.Ctx) error {
	resp, err := h.svc.Check(c.Context())
	if err != nil {
		return err
	}

	return httpx.OK(c, "Service is healthy.", resp)
}
