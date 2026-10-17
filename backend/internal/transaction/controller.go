package transaction

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
	var q ListTransactionsQuery
	if err := c.Bind().Query(&q); err != nil {
		return err
	}

	resp, meta, err := ctrl.svc.List(c.Context(), httpx.UserID(c), q)
	if err != nil {
		return err
	}

	return httpx.CursorPaginated(c, "Transactions retrieved successfully.", resp, meta)
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

	return httpx.OK(c, "Transaction retrieved successfully.", resp)
}

func (ctrl *Controller) Create(c fiber.Ctx) error {
	var req CreateTransactionRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Create(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.Created(c, "Transaction created successfully.", resp)
}

func (ctrl *Controller) Update(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	var req UpdateTransactionRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Update(c.Context(), httpx.UserID(c), id, req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Transaction updated successfully.", resp)
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

func (ctrl *Controller) Restore(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	resp, err := ctrl.svc.Restore(c.Context(), httpx.UserID(c), id)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Transaction restored successfully.", resp)
}

func (ctrl *Controller) UploadReceipt(c fiber.Ctx) error {
	f, err := httpx.FormFile(c)
	if err != nil {
		return err
	}
	defer f.Close()

	resp, err := ctrl.svc.UploadReceipt(c.Context(), httpx.UserID(c), f)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Receipt uploaded successfully.", resp)
}
