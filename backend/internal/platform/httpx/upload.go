package httpx

import (
	"bytes"
	"io"
	"maps"
	"net/http"
	"slices"
	"strconv"

	"github.com/gofiber/fiber/v3"
)

// sniffLen is how many leading bytes http.DetectContentType looks at.
const sniffLen = 512

// FileField is the multipart field every upload endpoint reads the file from.
const FileField = "file"

// ErrFileRequired is returned when the request has no file in FileField.
var ErrFileRequired = ErrValidationFailed.WithFields(FieldError{
	Field:   FileField,
	Code:    "required",
	Message: "must be a multipart/form-data file",
})

// File is an uploaded file. ContentType is detected from the bytes, never
// taken from the client. Close it when done.
type File struct {
	Body        io.Reader
	Size        int64
	ContentType string
	closer      io.Closer
}

func (f File) Close() error {
	if f.closer == nil {
		return nil
	}
	return f.closer.Close()
}

// FormFile opens the file in FileField and detects its content type.
func FormFile(c fiber.Ctx) (File, error) {
	fh, err := c.FormFile(FileField)
	if err != nil {
		return File{}, ErrFileRequired
	}

	r, err := fh.Open()
	if err != nil {
		return File{}, err
	}

	head := make([]byte, sniffLen)
	n, err := io.ReadFull(r, head)
	if err != nil && err != io.EOF && err != io.ErrUnexpectedEOF {
		_ = r.Close()
		return File{}, err
	}
	head = head[:n]

	return File{
		Body:        io.MultiReader(bytes.NewReader(head), r),
		Size:        fh.Size,
		ContentType: http.DetectContentType(head),
		closer:      r,
	}, nil
}

// FileRule is a feature's limit for one kind of upload.
type FileRule struct {
	MaxBytes int64
	Types    map[string]string // allowed content type → key extension (".png")
}

// Check validates f against the rule and returns the key extension for its
// type. Failures are 422 validation_failed on FileField.
func (r FileRule) Check(f File) (string, error) {
	if f.Size == 0 {
		return "", ErrFileRequired
	}
	if f.Size > r.MaxBytes {
		return "", ErrValidationFailed.WithFields(FieldError{
			Field:   FileField,
			Code:    "max_size",
			Message: "must be at most " + strconv.FormatInt(r.MaxBytes, 10) + " bytes",
			Params:  map[string]any{"max": r.MaxBytes},
		})
	}

	ext, ok := r.Types[f.ContentType]
	if !ok {
		allowed := slices.Sorted(maps.Keys(r.Types))
		return "", ErrValidationFailed.WithFields(FieldError{
			Field:   FileField,
			Code:    "content_type",
			Message: "must be one of the allowed file types",
			Params:  map[string]any{"allowed": allowed},
		})
	}

	return ext, nil
}
