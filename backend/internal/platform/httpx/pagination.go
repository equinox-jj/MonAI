package httpx

// Offset pagination defaults from the spec's Page and PerPage parameters.
const (
	DefaultPage    = 1
	DefaultPerPage = 20
)

// PageMeta is the spec's meta object for offset-paginated lists.
type PageMeta struct {
	Page       int   `json:"page"`
	PerPage    int   `json:"per_page"`
	Total      int64 `json:"total"`
	TotalPages int   `json:"total_pages"`
}

// NewPageMeta builds the meta for one page, defaulting page and perPage when
// they are not positive.
func NewPageMeta(page, perPage int, total int64) PageMeta {
	if page < 1 {
		page = DefaultPage
	}
	if perPage < 1 {
		perPage = DefaultPerPage
	}

	return PageMeta{
		Page:       page,
		PerPage:    perPage,
		Total:      total,
		TotalPages: int((total + int64(perPage) - 1) / int64(perPage)),
	}
}

// Offset is the number of rows before this page.
func (m PageMeta) Offset() int {
	return (m.Page - 1) * m.PerPage
}

// CursorMeta is the spec's meta object for cursor-paginated lists.
type CursorMeta struct {
	NextCursor *string `json:"next_cursor"` // null on the last page
	HasMore    bool    `json:"has_more"`
	Limit      int     `json:"limit"`
}
