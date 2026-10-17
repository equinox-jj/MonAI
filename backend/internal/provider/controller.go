package provider

import (
	"strconv"
	"strings"

	"github.com/gofiber/fiber/v3"

	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// catalogCacheControl lets clients and proxies reuse the public catalog
// briefly before revalidating with its ETag.
const catalogCacheControl = "public, max-age=300"

type Controller struct {
	svc Service
}

func NewController(svc Service) *Controller {
	return &Controller{svc: svc}
}

func (ctrl *Controller) Catalog(c fiber.Ctx) error {
	version, err := ctrl.svc.CatalogVersion(c.Context())
	if err != nil {
		return err
	}

	etag := `"v` + strconv.FormatInt(version, 10) + `"`
	c.Set(fiber.HeaderETag, etag)
	c.Set(fiber.HeaderCacheControl, catalogCacheControl)
	if etagMatches(c.Get(fiber.HeaderIfNoneMatch), etag) {
		return c.SendStatus(fiber.StatusNotModified)
	}

	resp, err := ctrl.svc.Catalog(c.Context())
	if err != nil {
		return err
	}

	// The catalog may have changed since the version check; send the ETag of
	// what is actually returned.
	if resp.Version != version {
		c.Set(fiber.HeaderETag, `"v`+strconv.FormatInt(resp.Version, 10)+`"`)
	}

	return httpx.OK(c, "Payment providers retrieved successfully.", resp)
}

func (ctrl *Controller) List(c fiber.Ctx) error {
	var q ListProvidersQuery
	if err := c.Bind().Query(&q); err != nil {
		return err
	}

	resp, meta, err := ctrl.svc.List(c.Context(), q)
	if err != nil {
		return err
	}

	return httpx.Paginated(c, "Payment providers retrieved successfully.", resp, meta)
}

func (ctrl *Controller) Get(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	resp, err := ctrl.svc.Get(c.Context(), id)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Payment provider retrieved successfully.", resp)
}

func (ctrl *Controller) Create(c fiber.Ctx) error {
	var req CreateProviderRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Create(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.Created(c, "Payment provider created successfully.", resp)
}

func (ctrl *Controller) Update(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	var req UpdateProviderRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.Update(c.Context(), httpx.UserID(c), id, req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Payment provider updated successfully.", resp)
}

func (ctrl *Controller) Delete(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	if err := ctrl.svc.Delete(c.Context(), id); err != nil {
		return err
	}

	return httpx.Deleted(c)
}

func (ctrl *Controller) SetStatus(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	var req ProviderStatusRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := ctrl.svc.SetStatus(c.Context(), httpx.UserID(c), id, *req.IsActive)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Payment provider status updated successfully.", resp)
}

func (ctrl *Controller) SetLogo(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	f, err := httpx.FormFile(c)
	if err != nil {
		return err
	}
	defer f.Close()

	resp, err := ctrl.svc.SetLogo(c.Context(), httpx.UserID(c), id, f)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Payment provider logo updated successfully.", resp)
}

// etagMatches reports whether an If-None-Match header matches etag. It
// accepts "*", comma-separated lists and weak (W/) tags.
func etagMatches(header, etag string) bool {
	for tag := range strings.SplitSeq(header, ",") {
		tag = strings.TrimPrefix(strings.TrimSpace(tag), "W/")
		if tag == "*" || tag == etag {
			return true
		}
	}

	return false
}
