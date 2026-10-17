package report

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

type Controller struct {
	svc Service
}

func NewController(svc Service) *Controller {
	return &Controller{svc: svc}
}

// Monthly handles GET /reports/monthly?month=YYYY-MM. A missing month fails
// the service's format check (422).
func (ctrl *Controller) Monthly(c fiber.Ctx) error {
	resp, err := ctrl.svc.Monthly(c.Context(), httpx.UserID(c), c.Query("month"))
	if err != nil {
		return err
	}

	return httpx.OK(c, "Report retrieved successfully.", resp)
}
