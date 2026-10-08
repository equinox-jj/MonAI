package security

import (
	"errors"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

type Claims struct {
	jwt.RegisteredClaims
}

type AccessToken struct {
	Token     string
	ExpiresIn int64
}

type JWTManager interface {
	Issue(userID uuid.UUID) (AccessToken, error)
	Parse(tokenString string) (*Claims, error)
}

type jwtManager struct {
	Config config.Config
}

func NewJWTManager(cfg config.Config) JWTManager {
	return &jwtManager{
		Config: cfg,
	}
}

// Issue implements [JWTManager].
func (j *jwtManager) Issue(userID uuid.UUID) (AccessToken, error) {
	panic("unimplemented")
}

// Parse implements [JWTManager].
func (j *jwtManager) Parse(tokenString string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(
		tokenString,
		&Claims{},
		func(t *jwt.Token) (any, error) {
			if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, errors.New("")
			}

			return []byte(""), nil
		},
	)
	if err != nil {
		if errors.Is(err, jwt.ErrTokenExpired) {
			return nil, err
		}
		return nil, err
	}

	claims, ok := token.Claims.(*Claims)
	if !ok || !token.Valid {
		return nil, err
	}

	return claims, nil
}
