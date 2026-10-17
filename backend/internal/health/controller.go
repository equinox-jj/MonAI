package health

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

func (ctrl *Controller) Check(c fiber.Ctx) error {
	resp, err := ctrl.svc.Check(c.Context())
	if err != nil {
		return err
	}

	return httpx.OK(c, "Service is healthy.", resp)
}
