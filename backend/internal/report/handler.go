package report

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

type Handler interface {
	Monthly(c fiber.Ctx) error
}

type handler struct {
	svc Service
}

func NewHandler(svc Service) Handler {
	return &handler{svc: svc}
}

// Monthly handles GET /reports/monthly?month=YYYY-MM. A missing month fails
// the service's format check (422).
func (h *handler) Monthly(c fiber.Ctx) error {
	resp, err := h.svc.Monthly(c.Context(), httpx.UserID(c), c.Query("month"))
	if err != nil {
		return err
	}

	return httpx.OK(c, "Report retrieved successfully.", resp)
}
