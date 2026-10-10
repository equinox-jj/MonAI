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

// Claims are the access token claims: sub (user ID), ver (the user's token
// version when issued), iss, iat and exp.
type Claims struct {
	jwt.RegisteredClaims
	Version int `json:"ver"`
}

// Subject is what a verified token identifies: the user and the token
// version it was issued under.
type Subject struct {
	UserID  uuid.UUID
	Version int
}

type AccessToken struct {
	Token     string
	ExpiresIn int64 // seconds, for AuthData.expires_in
}

type JWTManager interface {
	// Issue signs a token for the user at their current token version.
	Issue(userID uuid.UUID, version int) (AccessToken, error)
	// Parse verifies the token and returns its subject. Any failure is
	// ErrInvalidToken. Checking the version against the user's current one
	// is the caller's job.
	Parse(token string) (Subject, error)
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

func (j *jwtManager) Issue(userID uuid.UUID, version int) (AccessToken, error) {
	now := j.now().UTC()
	claims := Claims{
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   userID.String(),
			Issuer:    j.issuer,
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(now.Add(j.ttl)),
		},
		Version: version,
	}

	token, err := jwt.NewWithClaims(jwt.SigningMethodHS256, claims).SignedString(j.secret)
	if err != nil {
		return AccessToken{}, fmt.Errorf("security: sign token: %w", err)
	}

	return AccessToken{Token: token, ExpiresIn: int64(j.ttl.Seconds())}, nil
}

func (j *jwtManager) Parse(token string) (Subject, error) {
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
		return Subject{}, fmt.Errorf("%w: %v", ErrInvalidToken, err)
	}

	claims, ok := parsed.Claims.(*Claims)
	if !ok || !parsed.Valid {
		return Subject{}, ErrInvalidToken
	}

	userID, err := uuid.Parse(claims.Subject)
	if err != nil {
		return Subject{}, fmt.Errorf("%w: subject: %v", ErrInvalidToken, err)
	}

	// Tokens issued before versioning have no ver claim and decode as 0,
	// the column's default, so they stay valid until the first bump.
	return Subject{UserID: userID, Version: claims.Version}, nil
}
