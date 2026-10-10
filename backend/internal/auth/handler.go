package auth

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

type Handler interface {
	Register(c fiber.Ctx) error
	Login(c fiber.Ctx) error
	LogoutAll(c fiber.Ctx) error
	ChangePassword(c fiber.Ctx) error
}

type handler struct {
	svc Service
}

func NewHandler(svc Service) Handler {
	return &handler{svc: svc}
}

func (h *handler) Register(c fiber.Ctx) error {
	var req RegisterRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.Register(c.Context(), req)
	if err != nil {
		return err
	}

	return httpx.Created(c, "Account created successfully.", resp)
}

func (h *handler) Login(c fiber.Ctx) error {
	var req LoginRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.Login(c.Context(), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Logged in successfully.", resp)
}

func (h *handler) LogoutAll(c fiber.Ctx) error {
	if err := h.svc.LogoutAll(c.Context(), httpx.UserID(c)); err != nil {
		return err
	}

	return httpx.OK(c, "Logged out from all devices.", nil)
}

func (h *handler) ChangePassword(c fiber.Ctx) error {
	var req ChangePasswordRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.ChangePassword(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Password changed successfully.", resp)
}
