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

// The parts of other features the service uses, so a test fake implements only
// what is called. module.go adapts the real repositories and services to them.
type (
	Users interface {
		Create(ctx context.Context, u *user.User) error
		FindByID(ctx context.Context, id uuid.UUID) (*user.User, error)
		FindByEmail(ctx context.Context, email string) (*user.User, error)
		UpdatePassword(ctx context.Context, id uuid.UUID, hash string) (*user.User, error)
		BumpTokenVersion(ctx context.Context, id uuid.UUID) error
	}

	Profiles interface {
		GetMe(ctx context.Context, userID uuid.UUID) (user.MeResponse, error)
	}

	Roles interface {
		DefaultRole(ctx context.Context) (*rbac.Role, error)
	}

	WalletSeeder interface {
		SeedDefault(ctx context.Context, userID uuid.UUID) error
	}

	CategorySeeder interface {
		SeedDefaults(ctx context.Context, userID uuid.UUID) error
	}
)

type Service interface {
	// Register creates the user with the default role and returns a token.
	Register(ctx context.Context, req RegisterRequest) (AuthResponse, error)
	// Login returns ErrInvalidCredentials for an unknown email and for a
	// wrong password alike.
	Login(ctx context.Context, req LoginRequest) (AuthResponse, error)
	// LogoutAll revokes every token of the user, this one included.
	LogoutAll(ctx context.Context, userID uuid.UUID) error
	// ChangePassword checks the current password (user.ErrInvalidPassword),
	// stores the new one, revokes every older token and returns a new one.
	ChangePassword(ctx context.Context, userID uuid.UUID, req ChangePasswordRequest) (AuthResponse, error)
}

type service struct {
	users      Users
	me         Profiles
	roles      Roles
	categories CategorySeeder
	wallets    WalletSeeder
	jwt        security.JWTManager
	hasher     security.PasswordHasher
	tx         database.TxManager
}

func NewService(
	users Users,
	me Profiles,
	roles Roles,
	categories CategorySeeder,
	wallets WalletSeeder,
	jwt security.JWTManager,
	hasher security.PasswordHasher,
	tx database.TxManager,
) Service {
	return &service{
		users:      users,
		me:         me,
		roles:      roles,
		categories: categories,
		wallets:    wallets,
		jwt:        jwt,
		hasher:     hasher,
		tx:         tx,
	}
}

func (s *service) Register(ctx context.Context, req RegisterRequest) (AuthResponse, error) {
	// Hash outside the transaction: bcrypt is slow.
	hash, err := s.hasher.Hash(req.Password)
	if err != nil {
		return AuthResponse{}, err
	}

	u := &user.User{
		Name:         strings.TrimSpace(req.Name),
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

		if err := s.wallets.SeedDefault(ctx, u.ID); err != nil {
			return err
		}
		return s.categories.SeedDefaults(ctx, u.ID)
	})
	if err != nil {
		return AuthResponse{}, err
	}

	return s.issue(ctx, u)
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

	return s.issue(ctx, u)
}

func (s *service) LogoutAll(ctx context.Context, userID uuid.UUID) error {
	return s.users.BumpTokenVersion(ctx, userID)
}

func (s *service) ChangePassword(ctx context.Context, userID uuid.UUID, req ChangePasswordRequest) (AuthResponse, error) {
	u, err := s.users.FindByID(ctx, userID)
	if err != nil {
		return AuthResponse{}, err
	}

	ok, err := s.hasher.Verify(u.PasswordHash, req.CurrentPassword)
	if err != nil {
		return AuthResponse{}, err
	}
	if !ok {
		return AuthResponse{}, user.ErrInvalidPassword
	}

	hash, err := s.hasher.Hash(req.NewPassword)
	if err != nil {
		return AuthResponse{}, err
	}

	if u, err = s.users.UpdatePassword(ctx, userID, hash); err != nil {
		return AuthResponse{}, err
	}

	return s.issue(ctx, u)
}

// issue signs an access token for u at its current token version and builds
// the auth response.
func (s *service) issue(ctx context.Context, u *user.User) (AuthResponse, error) {
	token, err := s.jwt.Issue(u.ID, u.TokenVersion)
	if err != nil {
		return AuthResponse{}, err
	}

	me, err := s.me.GetMe(ctx, u.ID)
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
