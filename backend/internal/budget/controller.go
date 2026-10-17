package budget

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

func (ctrl *Controller) Get(c fiber.Ctx) error {
	resp, err := ctrl.svc.Get(c.Context(), httpx.UserID(c), c.Params("month"))
	if err != nil {
		return err
	}

	return httpx.OK(c, "Budget retrieved successfully.", resp)
}

func (ctrl *Controller) Set(c fiber.Ctx) error {
	var req SetBudgetRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Set(c.Context(), httpx.UserID(c), c.Params("month"), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Budget saved successfully.", resp)
}

func (ctrl *Controller) Delete(c fiber.Ctx) error {
	if err := ctrl.svc.Delete(c.Context(), httpx.UserID(c), c.Params("month")); err != nil {
		return err
	}

	return httpx.Deleted(c)
}
