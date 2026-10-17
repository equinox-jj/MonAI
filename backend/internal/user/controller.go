package user

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

func (ctrl *Controller) GetMe(c fiber.Ctx) error {
	resp, err := ctrl.svc.GetMe(c.Context(), httpx.UserID(c))
	if err != nil {
		return err
	}

	return httpx.OK(c, "Retrieved successfully.", resp)
}

func (ctrl *Controller) UpdateMe(c fiber.Ctx) error {
	var req UpdateMeRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.UpdateMe(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Profile updated successfully.", resp)
}

func (ctrl *Controller) DeleteMe(c fiber.Ctx) error {
	var req DeleteAccountRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	if err := ctrl.svc.DeleteAccount(c.Context(), httpx.UserID(c), req); err != nil {
		return err
	}

	return httpx.Deleted(c)
}

func (ctrl *Controller) SetAvatar(c fiber.Ctx) error {
	f, err := httpx.FormFile(c)
	if err != nil {
		return err
	}
	defer f.Close()

	resp, err := ctrl.svc.SetAvatar(c.Context(), httpx.UserID(c), f)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Avatar updated successfully.", resp)
}

func (ctrl *Controller) DeleteAvatar(c fiber.Ctx) error {
	if err := ctrl.svc.DeleteAvatar(c.Context(), httpx.UserID(c)); err != nil {
		return err
	}

	return httpx.Deleted(c)
}
