package httpx

import "encoding/json"

// Optional is a PATCH body field that tells an absent key apart from JSON
// null. Set is false when the key is absent; Value holds the decoded value,
// nil for null when T is a pointer.
type Optional[T any] struct {
	Set   bool
	Value T
}

func (o *Optional[T]) UnmarshalJSON(b []byte) error {
	o.Set = true
	return json.Unmarshal(b, &o.Value)
}
