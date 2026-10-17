package category

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

type Controller struct {
	svc Service
}

func NewController(svc Service) *Controller {
	return &Controller{svc: svc}
}

func (ctrl *Controller) List(c fiber.Ctx) error {
	var q ListCategoriesQuery
	if err := c.Bind().Query(&q); err != nil {
		return err
	}

	resp, err := ctrl.svc.List(c.Context(), httpx.UserID(c), q)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Categories retrieved successfully.", resp)
}

func (ctrl *Controller) Create(c fiber.Ctx) error {
	var req CreateCategoryRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Create(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.Created(c, "Category created successfully.", resp)
}

func (ctrl *Controller) Update(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	var req UpdateCategoryRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Update(c.Context(), httpx.UserID(c), id, req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Category updated successfully.", resp)
}

func (ctrl *Controller) Delete(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	moveTo, err := parseMoveTo(c.Query("move_to"))
	if err != nil {
		return err
	}

	if err := ctrl.svc.Delete(c.Context(), httpx.UserID(c), id, moveTo); err != nil {
		return err
	}

	return httpx.Deleted(c)
}

// parseMoveTo returns nil when move_to is absent and ErrMoveToInvalid when it
// is not a UUID.
func parseMoveTo(raw string) (*uuid.UUID, error) {
	if raw == "" {
		return nil, nil
	}

	id, err := uuid.Parse(raw)
	if err != nil {
		return nil, ErrMoveToInvalid
	}

	return &id, nil
}
