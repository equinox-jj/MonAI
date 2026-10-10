package user

import (
	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

type Handler interface {
	GetMe(c fiber.Ctx) error
	UpdateMe(c fiber.Ctx) error
	DeleteMe(c fiber.Ctx) error
	SetAvatar(c fiber.Ctx) error
	DeleteAvatar(c fiber.Ctx) error
}

type handler struct {
	svc Service
}

func NewHandler(svc Service) Handler {
	return &handler{svc: svc}
}

func (h *handler) GetMe(c fiber.Ctx) error {
	resp, err := h.svc.GetMe(c.Context(), httpx.UserID(c))
	if err != nil {
		return err
	}

	return httpx.OK(c, "Retrieved successfully.", resp)
}

func (h *handler) UpdateMe(c fiber.Ctx) error {
	var req UpdateMeRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.UpdateMe(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Profile updated successfully.", resp)
}

func (h *handler) DeleteMe(c fiber.Ctx) error {
	var req DeleteAccountRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	if err := h.svc.DeleteAccount(c.Context(), httpx.UserID(c), req); err != nil {
		return err
	}

	return httpx.Deleted(c)
}

func (h *handler) SetAvatar(c fiber.Ctx) error {
	f, err := httpx.FormFile(c)
	if err != nil {
		return err
	}
	defer f.Close()

	resp, err := h.svc.SetAvatar(c.Context(), httpx.UserID(c), f)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Avatar updated successfully.", resp)
}

func (h *handler) DeleteAvatar(c fiber.Ctx) error {
	if err := h.svc.DeleteAvatar(c.Context(), httpx.UserID(c)); err != nil {
		return err
	}

	return httpx.Deleted(c)
}
