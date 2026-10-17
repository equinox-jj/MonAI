package ai

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

func (ctrl *Controller) ParseTransaction(c fiber.Ctx) error {
	var req ParseTransactionRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.ParseTransaction(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Drafts generated successfully.", resp)
}

func (ctrl *Controller) ParseReceipt(c fiber.Ctx) error {
	var req ParseReceiptRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.ParseReceipt(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Draft generated successfully.", resp)
}
