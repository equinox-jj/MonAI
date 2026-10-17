package auth

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

func (ctrl *Controller) Register(c fiber.Ctx) error {
	var req RegisterRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Register(c.Context(), req)
	if err != nil {
		return err
	}

	return httpx.Created(c, "Account created successfully.", resp)
}

func (ctrl *Controller) Login(c fiber.Ctx) error {
	var req LoginRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Login(c.Context(), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Logged in successfully.", resp)
}

func (ctrl *Controller) LogoutAll(c fiber.Ctx) error {
	if err := ctrl.svc.LogoutAll(c.Context(), httpx.UserID(c)); err != nil {
		return err
	}

	return httpx.OK(c, "Logged out from all devices.", nil)
}

func (ctrl *Controller) ChangePassword(c fiber.Ctx) error {
	var req ChangePasswordRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.ChangePassword(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Password changed successfully.", resp)
}
