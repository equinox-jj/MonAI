package security

import (
	"errors"
	"fmt"
	"time"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

// ErrInvalidToken is returned by Parse for every failure (bad signature,
// expired, wrong algorithm or issuer, malformed subject). Callers map it to
// 401 unauthorized without branching on the reason.
var ErrInvalidToken = errors.New("security: invalid token")

// Claims are the access token claims: sub (user ID), iss, iat and exp.
type Claims struct {
	jwt.RegisteredClaims
}

type AccessToken struct {
	Token     string
	ExpiresIn int64 // seconds, for AuthData.expires_in
}

type JWTManager interface {
	Issue(userID uuid.UUID) (AccessToken, error)
	// Parse verifies the token and returns its subject. Any failure is
	// ErrInvalidToken.
	Parse(token string) (uuid.UUID, error)
}

type jwtManager struct {
	secret []byte
	issuer string
	ttl    time.Duration
	now    func() time.Time
}

func NewJWTManager(cfg config.Config) JWTManager {
	return newJWTManager([]byte(cfg.JWT.Secret), cfg.JWT.Issuer, cfg.JWT.AccessTTL, time.Now)
}

// newJWTManager lets tests inject a fixed clock.
func newJWTManager(secret []byte, issuer string, ttl time.Duration, now func() time.Time) *jwtManager {
	return &jwtManager{secret: secret, issuer: issuer, ttl: ttl, now: now}
}

func (j *jwtManager) Issue(userID uuid.UUID) (AccessToken, error) {
	now := j.now().UTC()
	claims := Claims{
		Subject:   userID.String(),
		Issuer:    j.issuer,
		IssuedAt:  jwt.NewNumericDate(now),
		ExpiresAt: jwt.NewNumericDate(now.Add(j.ttl)),
	}

	token, err := jwt.NewWithClaims(jwt.SigningMethodHS256, claims).SignedString(j.secret)
	if err != nil {
		return AccessToken{}, fmt.Errorf("security: sign token: %w", err)
	}

	return AccessToken{Token: token, ExpiresIn: int64(j.ttl.Seconds())}, nil
}

func (j *jwtManager) Parse(token string) (uuid.UUID, error) {
	parsed, err := jwt.ParseWithClaims(
		token,
		&Claims{},
		func(*jwt.Token) (any, error) { return j.secret, nil },
		jwt.WithValidMethods([]string{jwt.SigningMethodHS256.Alg()}),
		jwt.WithExpirationRequired(),
		jwt.WithIssuedAt(),
		jwt.WithIssuer(j.issuer),
		jwt.WithTimeFunc(j.now),
	)
	if err != nil {
		return uuid.Nil, fmt.Errorf("%w: %v", ErrInvalidToken, err)
	}

	claims, ok := parsed.Claims.(*Claims)
	if !ok || !parsed.Valid {
		return uuid.Nil, ErrInvalidToken
	}

	userID, err := uuid.Parse(claims.Subject)
	if err != nil {
		return uuid.Nil, fmt.Errorf("%w: subject: %v", ErrInvalidToken, err)
	}

	return userID, nil
}
