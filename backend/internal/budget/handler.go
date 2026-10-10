package budget

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

type Handler interface {
	Get(c fiber.Ctx) error
	Set(c fiber.Ctx) error
	Delete(c fiber.Ctx) error
}

type handler struct {
	svc Service
}

func NewHandler(svc Service) Handler {
	return &handler{svc: svc}
}

func (h *handler) Get(c fiber.Ctx) error {
	resp, err := h.svc.Get(c.Context(), httpx.UserID(c), c.Params("month"))
	if err != nil {
		return err
	}

	return httpx.OK(c, "Budget retrieved successfully.", resp)
}

func (h *handler) Set(c fiber.Ctx) error {
	var req SetBudgetRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.Set(c.Context(), httpx.UserID(c), c.Params("month"), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Budget saved successfully.", resp)
}

func (h *handler) Delete(c fiber.Ctx) error {
	if err := h.svc.Delete(c.Context(), httpx.UserID(c), c.Params("month")); err != nil {
		return err
	}

	return httpx.Deleted(c)
}
