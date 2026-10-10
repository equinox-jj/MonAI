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

type Handler interface {
	Catalog(c fiber.Ctx) error
	List(c fiber.Ctx) error
	Get(c fiber.Ctx) error
	Create(c fiber.Ctx) error
	Update(c fiber.Ctx) error
	Delete(c fiber.Ctx) error
	SetStatus(c fiber.Ctx) error
	SetLogo(c fiber.Ctx) error
}

type handler struct {
	svc Service
}

func NewHandler(svc Service) Handler {
	return &handler{svc: svc}
}

func (h *handler) Catalog(c fiber.Ctx) error {
	version, err := h.svc.CatalogVersion(c.Context())
	if err != nil {
		return err
	}

	etag := `"v` + strconv.FormatInt(version, 10) + `"`
	c.Set(fiber.HeaderETag, etag)
	c.Set(fiber.HeaderCacheControl, catalogCacheControl)
	if etagMatches(c.Get(fiber.HeaderIfNoneMatch), etag) {
		return c.SendStatus(fiber.StatusNotModified)
	}

	resp, err := h.svc.Catalog(c.Context())
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

func (h *handler) List(c fiber.Ctx) error {
	var q ListProvidersQuery
	if err := c.Bind().Query(&q); err != nil {
		return err
	}

	resp, meta, err := h.svc.List(c.Context(), q)
	if err != nil {
		return err
	}

	return httpx.Paginated(c, "Payment providers retrieved successfully.", resp, meta)
}

func (h *handler) Get(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	resp, err := h.svc.Get(c.Context(), id)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Payment provider retrieved successfully.", resp)
}

func (h *handler) Create(c fiber.Ctx) error {
	var req CreateProviderRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.Create(c.Context(), httpx.UserID(c), req)
	if err != nil {
		return err
	}

	return httpx.Created(c, "Payment provider created successfully.", resp)
}

func (h *handler) Update(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	var req UpdateProviderRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.Update(c.Context(), httpx.UserID(c), id, req)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Payment provider updated successfully.", resp)
}

func (h *handler) Delete(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	if err := h.svc.Delete(c.Context(), id); err != nil {
		return err
	}

	return httpx.Deleted(c)
}

func (h *handler) SetStatus(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	var req ProviderStatusRequest
	if err := c.Bind().Body(&req); err != nil {
		return err
	}

	resp, err := h.svc.SetStatus(c.Context(), httpx.UserID(c), id, *req.IsActive)
	if err != nil {
		return err
	}

	return httpx.OK(c, "Payment provider status updated successfully.", resp)
}

func (h *handler) SetLogo(c fiber.Ctx) error {
	id, err := httpx.ParamUUID(c, "id")
	if err != nil {
		return err
	}

	f, err := httpx.FormFile(c)
	if err != nil {
		return err
	}
	defer f.Close()

	resp, err := h.svc.SetLogo(c.Context(), httpx.UserID(c), id, f)
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
