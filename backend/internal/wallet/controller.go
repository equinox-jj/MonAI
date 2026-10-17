package wallet

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

func (ctrl *Controller) List(c fiber.Ctx) error {
	var q ListWalletsQuery
	if err := c.Bind().Query(&q); err != nil {
		return err
	}

	resp, meta, err := ctrl.svc.List(c.Context(), httpx.UserID(c), q)
	if err != nil {
		return err
	}

	return httpx.OKWithMeta(c, "Wallets retrieved successfully.", resp, meta)
}

func (ctrl *Controller) Get(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	resp, err := ctrl.svc.Get(c.Context(), httpx.UserID(c), id)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Wallet retrieved successfully.", resp)
}

func (ctrl *Controller) Create(c fiber.Ctx) error {
	var req CreateWalletRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Create(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.Created(c, "Wallet created successfully.", resp)
}

func (ctrl *Controller) Update(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	var req UpdateWalletRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Update(c.Context(), httpx.UserID(c), id, req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Wallet updated successfully.", resp)
}

func (ctrl *Controller) Delete(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	if err := ctrl.svc.Delete(c.Context(), httpx.UserID(c), id); err != nil {
		return err
	}

	return httpx.Deleted(c)
}
