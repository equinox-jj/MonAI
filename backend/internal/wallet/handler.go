package wallet

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

type Handler interface {
	List(c fiber.Ctx) error
	Get(c fiber.Ctx) error
	Create(c fiber.Ctx) error
	Update(c fiber.Ctx) error
	Delete(c fiber.Ctx) error
}

type handler struct {
	svc Service
}

func NewHandler(svc Service) Handler {
	return &handler{svc: svc}
}

func (h *handler) List(c fiber.Ctx) error {
	var q ListWalletsQuery
	if err := c.Bind().Query(&q); err != nil {
		return err
	}

	resp, meta, err := h.svc.List(c.Context(), httpx.UserID(c), q)
	if err != nil {
		return err
	}

	return httpx.OKWithMeta(c, "Wallets retrieved successfully.", resp, meta)
}

func (h *handler) Get(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	resp, err := h.svc.Get(c.Context(), httpx.UserID(c), id)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Wallet retrieved successfully.", resp)
}

func (h *handler) Create(c fiber.Ctx) error {
	var req CreateWalletRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.Create(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.Created(c, "Wallet created successfully.", resp)
}

func (h *handler) Update(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	var req UpdateWalletRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.Update(c.Context(), httpx.UserID(c), id, req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Wallet updated successfully.", resp)
}

func (h *handler) Delete(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	if err := h.svc.Delete(c.Context(), httpx.UserID(c), id); err != nil {
		return err
	}

	return httpx.Deleted(c)
}
