package transaction

import (
	"encoding/base64"
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// cursorJSON is the opaque cursor's payload: the last row's date and ID.
type cursorJSON struct {
	D string    `json:"d"`
	I uuid.UUID `json:"i"`
}

// encodeCursor returns the opaque cursor that resumes the list after t.
func encodeCursor(t *Transaction) string {
	b, _ := json.Marshal(cursorJSON{
		D: t.Date.Format(dateLayout),
		I: t.ID,
	})
	
	return base64.RawURLEncoding.EncodeToString(b)
}

// decodeCursor parses an opaque cursor, returning ErrInvalidCursor when it
// is malformed.
func decodeCursor(s string) (*Cursor, error) {
	b, err := base64.RawURLEncoding.DecodeString(s)
	if err != nil {
		return nil, ErrInvalidCursor
	}

	var c cursorJSON
	if err := json.Unmarshal(b, &c); err != nil || c.I == uuid.Nil {
		return nil, ErrInvalidCursor
	}

	d, err := time.Parse(dateLayout, c.D)
	if err != nil {
		return nil, ErrInvalidCursor
	}

	return &Cursor{Date: d, ID: c.I}, nil
}
