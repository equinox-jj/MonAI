package security

import (
	"errors"

	"golang.org/x/crypto/bcrypt"
)

const bcryptCost = 12

type PasswordHasher interface {
	Hash(plain string) (string, error)
	// Verify reports whether plain matches hash. A mismatch is (false, nil);
	// only a malformed hash or a bcrypt failure returns an error.
	Verify(hash, plain string) (bool, error)
}

type passwordHasher struct{}

func NewPasswordHasher() PasswordHasher {
	return &passwordHasher{}
}

// Hash returns bcrypt.ErrPasswordTooLong for passwords over 72 bytes; request
// validation should reject those first.
func (passwordHasher) Hash(plain string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(plain), bcryptCost)
	if err != nil {
		return "", err
	}
	return string(hash), nil
}

func (passwordHasher) Verify(hash, plain string) (bool, error) {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(plain))
	if errors.Is(err, bcrypt.ErrMismatchedHashAndPassword) {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	return true, nil
}
