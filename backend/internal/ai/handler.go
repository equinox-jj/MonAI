package ai

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

type Handler interface {
	ParseTransaction(c fiber.Ctx) error
	ParseReceipt(c fiber.Ctx) error
}

type handler struct {
	svc Service
}

func NewHandler(svc Service) Handler {
	return &handler{svc: svc}
}

func (h *handler) ParseTransaction(c fiber.Ctx) error {
	var req ParseTransactionRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.ParseTransaction(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Drafts generated successfully.", resp)
}

func (h *handler) ParseReceipt(c fiber.Ctx) error {
	var req ParseReceiptRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.ParseReceipt(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Draft generated successfully.", resp)
}
