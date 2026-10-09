package auth

import (
	"context"
	"errors"
	"strings"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/security"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
	"github.com/equinox-jj/MonAI/backend/internal/user"
)

// dummyHash is a cost-12 bcrypt hash of a random string. Login verifies
// against it when the email is unknown, so that path takes as long as a wrong
// password and does not reveal which accounts exist.
const dummyHash = "$2a$12$jzIdCIei52/B540l5Nk2re4NwCvTRnfw/TldVrk5WBnkzvPzcLVCG"

type Service interface {
	// Register creates the user with the default role and returns a token.
	Register(ctx context.Context, req RegisterRequest) (AuthResponse, error)
	// Login returns ErrInvalidCredentials for an unknown email and for a
	// wrong password alike.
	Login(ctx context.Context, req LoginRequest) (AuthResponse, error)
}

type service struct {
	users  user.Repository
	me     user.Service
	roles  rbac.Service
	jwt    security.JWTManager
	hasher security.PasswordHasher
	tx     database.TxManager
}

func NewService(
	users user.Repository,
	me user.Service,
	roles rbac.Service,
	jwt security.JWTManager,
	hasher security.PasswordHasher,
	tx database.TxManager,
) Service {
	return &service{
		users:  users,
		me:     me,
		roles:  roles,
		jwt:    jwt,
		hasher: hasher,
		tx:     tx,
	}
}

func (s *service) Register(ctx context.Context, req RegisterRequest) (AuthResponse, error) {
	name := strings.TrimSpace(req.Name)
	if name == "" {
		return AuthResponse{}, user.ErrNameBlank
	}

	// Hash outside the transaction: bcrypt is slow.
	hash, err := s.hasher.Hash(req.Password)
	if err != nil {
		return AuthResponse{}, err
	}

	u := &user.User{
		Name:         name,
		Email:        normalizeEmail(req.Email),
		PasswordHash: hash,
	}
	err = s.tx.WithinTx(ctx, func(ctx context.Context) error {
		role, err := s.roles.DefaultRole(ctx)
		if err != nil {
			return err
		}
		u.RoleID = role.ID

		if err := s.users.Create(ctx, u); err != nil {
			return err
		}

		// TODO(phase 1b): seed default wallet and categories
		return nil
	})
	if err != nil {
		return AuthResponse{}, err
	}

	return s.issue(ctx, u.ID)
}

func (s *service) Login(ctx context.Context, req LoginRequest) (AuthResponse, error) {
	u, err := s.users.FindByEmail(ctx, normalizeEmail(req.Email))
	if errors.Is(err, user.ErrNotFound) {
		_, _ = s.hasher.Verify(dummyHash, req.Password)
		return AuthResponse{}, ErrInvalidCredentials
	}
	if err != nil {
		return AuthResponse{}, err
	}

	ok, err := s.hasher.Verify(u.PasswordHash, req.Password)
	if err != nil {
		return AuthResponse{}, err
	}
	if !ok {
		return AuthResponse{}, ErrInvalidCredentials
	}

	return s.issue(ctx, u.ID)
}

// issue signs an access token for userID and builds the auth response.
func (s *service) issue(ctx context.Context, userID uuid.UUID) (AuthResponse, error) {
	token, err := s.jwt.Issue(userID)
	if err != nil {
		return AuthResponse{}, err
	}

	me, err := s.me.GetMe(ctx, userID)
	if err != nil {
		return AuthResponse{}, err
	}

	return AuthResponse{
		AccessToken: token.Token,
		TokenType:   TokenTypeBearer,
		ExpiresIn:   token.ExpiresIn,
		User:        me,
	}, nil
}

func normalizeEmail(email string) string {
	return strings.ToLower(strings.TrimSpace(email))
}
