package httpx

import (
	"errors"
	"fmt"
	"reflect"
	"strconv"
	"strings"
	"unicode"

	"github.com/go-playground/validator/v10"
	"github.com/google/uuid"
)

// FieldError is one invalid field, shaped like the API spec's FieldError.
type FieldError struct {
	Field   string         `json:"field"`
	Code    string         `json:"code"`
	Message string         `json:"message"`
	Params  map[string]any `json:"params,omitempty"`
}

// ValidationError is returned by Validate when one or more fields are invalid.
// Handlers map it to a 422 validation_failed response.
type ValidationError struct {
	Fields []FieldError
}

func (e *ValidationError) Error() string {
	parts := make([]string, len(e.Fields))
	for i, f := range e.Fields {
		parts[i] = f.Field + " " + f.Message
	}
	return "validation failed: " + strings.Join(parts, "; ")
}

// Validator wraps go-playground/validator. It satisfies fiber.StructValidator,
// so c.Bind().Body(&req) validates the request after decoding it.
type Validator struct {
	v *validator.Validate
}

// NewValidator builds a Validator that reports fields by their JSON names and knows
// the project's custom tags.
func NewValidator() *Validator {
	v := validator.New(validator.WithRequiredStructEnabled())

	v.RegisterTagNameFunc(func(f reflect.StructField) string {
		name, _, _ := strings.Cut(f.Tag.Get("json"), ",")
		if name == "-" {
			return ""
		}
		if name == "" {
			return f.Name
		}
		return name
	})

	// requires_digit: the string contains at least one digit (passwords).
	_ = v.RegisterValidation("requires_digit", func(fl validator.FieldLevel) bool {
		return strings.ContainsFunc(fl.Field().String(), unicode.IsDigit)
	})

	// Every Optional type used in a request DTO must be registered here, or
	// its validate tags are silently skipped.
	registerOptional[string](v)
	registerOptional[uuid.UUID](v)

	return &Validator{v: v}
}

// registerOptional validates an Optional[*T] by its inner value. Absent or
// null yields nil, so omitempty skips it.
func registerOptional[T any](v *validator.Validate) {
	v.RegisterCustomTypeFunc(func(f reflect.Value) any {
		o := f.Interface().(Optional[*T])
		if !o.Set || o.Value == nil {
			return nil
		}
		return *o.Value
	}, Optional[*T]{})
}

// Validate checks s against its `validate` tags. It returns *ValidationError for invalid
// fields and any other error for misuse (e.g. s is not a struct).
func (val *Validator) Validate(s any) error {
	err := val.v.Struct(s)
	if err == nil {
		return nil
	}

	var verrs validator.ValidationErrors
	if !errors.As(err, &verrs) {
		return err
	}

	fields := make([]FieldError, len(verrs))
	for i, fe := range verrs {
		fields[i] = toFieldError(fe)
	}
	return &ValidationError{Fields: fields}
}

// toFieldError maps a validator error to the API's field error codes.
func toFieldError(fe validator.FieldError) FieldError {
	out := FieldError{Field: fieldPath(fe.Namespace())}
	isLen := isLengthKind(fe.Kind())
	param := fe.Param()

	switch fe.Tag() {
	case "required", "required_if", "required_unless", "required_with", "required_without":
		out.Code, out.Message = "required", "is required"

	case "min", "gte":
		if isLen {
			out.Code, out.Message = "min_length", fmt.Sprintf("must be at least %s characters", param)
		} else {
			out.Code, out.Message = "min", "must be at least "+param
		}
		out.Params = map[string]any{"min": number(param)}

	case "max", "lte":
		if isLen {
			out.Code, out.Message = "max_length", fmt.Sprintf("must be at most %s characters", param)
		} else {
			out.Code, out.Message = "max", "must be at most "+param
		}
		out.Params = map[string]any{"max": number(param)}

	case "gt":
		out.Code, out.Message = "min", "must be greater than "+param
		out.Params = map[string]any{"min": number(param)}

	case "lt":
		out.Code, out.Message = "max", "must be less than "+param
		out.Params = map[string]any{"max": number(param)}

	case "len":
		out.Code, out.Message = "invalid_format", fmt.Sprintf("must have length %s", param)
		out.Params = map[string]any{"len": number(param)}

	case "oneof":
		values := strings.Fields(param)
		out.Code, out.Message = "one_of", "must be one of: "+strings.Join(values, ", ")
		out.Params = map[string]any{"values": values}

	case "nefield":
		other := toSnake(param) // param is the Go field name; json tags are its snake_case

		out.Code, out.Message = "not_equal", "must be different from "+other
		out.Params = map[string]any{"other": other}

	case "requires_digit":
		out.Code, out.Message = "requires_digit", "must contain at least one digit"

	default:
		// email, uuid, url, datetime, numeric, … all mean "wrong shape".
		out.Code, out.Message = "invalid_format", "is not a valid "+fe.Tag()
	}

	return out
}

// fieldPath drops the root struct name: "CreateTxRequest.items[0].amount" → "items[0].amount".
func fieldPath(ns string) string {
	_, rest, found := strings.Cut(ns, ".")
	if !found {
		return ns
	}
	return rest
}

func toSnake(s string) string {
	var b strings.Builder
	runes := []rune(s)
	for i, r := range runes {
		if unicode.IsUpper(r) {
			if i > 0 && (unicode.IsLower(runes[i-1]) || (i+1 < len(runes) && unicode.IsLower(runes[i+1]))) {
				b.WriteByte('_')
			}
			r = unicode.ToLower(r)
		}
		b.WriteRune(r)
	}
	return b.String()
}

func isLengthKind(k reflect.Kind) bool {
	switch k {
	case reflect.String, reflect.Slice, reflect.Array, reflect.Map:
		return true
	}
	return false
}

// number returns param as a number when it parses as one, so params serialise as {"min": 1}.
func number(param string) any {
	if n, err := strconv.ParseInt(param, 10, 64); err == nil {
		return n
	}
	if f, err := strconv.ParseFloat(param, 64); err == nil {
		return f
	}
	return param
}
