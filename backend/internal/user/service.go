package user

import (
	"context"
	"log/slog"
	"strings"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
	"github.com/equinox-jj/MonAI/backend/internal/platform/security"
	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
)

// avatarRule limits avatar uploads and maps their types to key extensions.
var avatarRule = httpx.FileRule{
	MaxBytes: AvatarMaxSizeBytes,
	Types: map[string]string{
		"image/jpeg": ".jpg",
		"image/png":  ".png",
		"image/webp": ".webp",
	},
}

type Service interface {
	GetMe(ctx context.Context, userID uuid.UUID) (MeResponse, error)
	UpdateMe(ctx context.Context, userID uuid.UUID, req UpdateMeRequest) (MeResponse, error)
	// DeleteAccount checks the password, deletes the user (their data cascades
	// in the DB) and then removes their avatar and receipt objects.
	DeleteAccount(ctx context.Context, userID uuid.UUID, req DeleteAccountRequest) error
	// SetAvatar checks and stores f, saves it on the user and deletes the
	// previous avatar.
	SetAvatar(ctx context.Context, userID uuid.UUID, f httpx.File) (MeResponse, error)
	// DeleteAvatar clears the avatar. It is a no-op when none is set.
	DeleteAvatar(ctx context.Context, userID uuid.UUID) error
}

type service struct {
	repo   Repository
	roles  rbac.Service
	store  storage.Storage
	hasher security.PasswordHasher
	tx     database.TxManager
	log    *slog.Logger
	bucket string // private bucket holding avatars and receipts
}

func NewService(
	repo Repository,
	roles rbac.Service,
	store storage.Storage,
	hasher security.PasswordHasher,
	tx database.TxManager,
	log *slog.Logger,
	cfg config.Config,
) Service {
	return &service{
		repo:   repo,
		roles:  roles,
		store:  store,
		hasher: hasher,
		tx:     tx,
		log:    log,
		bucket: cfg.MinIO.BucketPrivate,
	}
}

func (s *service) GetMe(ctx context.Context, userID uuid.UUID) (MeResponse, error) {
	u, err := s.repo.FindByID(ctx, userID)
	if err != nil {
		return MeResponse{}, err
	}

	return s.toMe(ctx, u)
}

func (s *service) UpdateMe(ctx context.Context, userID uuid.UUID, req UpdateMeRequest) (MeResponse, error) {
	name := strings.TrimSpace(req.Name)
	if name == "" {
		return MeResponse{}, ErrNameBlank
	}

	u, err := s.repo.UpdateName(ctx, userID, name)
	if err != nil {
		return MeResponse{}, err
	}

	return s.toMe(ctx, u)
}

func (s *service) DeleteAccount(ctx context.Context, userID uuid.UUID, req DeleteAccountRequest) error {
	u, err := s.repo.FindByID(ctx, userID)
	if err != nil {
		return err
	}

	// Verify outside the transaction: bcrypt is slow and the last_admin
	// check below holds row locks until commit.
	ok, err := s.hasher.Verify(u.PasswordHash, req.Password)
	if err != nil {
		return err
	}
	if !ok {
		return ErrInvalidPassword
	}

	err = s.tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.roles.EnsureNotLastAdmin(ctx, u.ID, u.RoleID); err != nil {
			return err
		}

		return s.repo.Delete(ctx, u.ID)
	})
	if err != nil {
		return err
	}

	// The account is gone, so a storage failure only leaves orphaned objects
	// and must not fail the request.
	for _, prefix := range []string{avatarPrefix(u.ID), receiptPrefix(u.ID)} {
		if err := s.store.DeletePrefix(ctx, s.bucket, prefix); err != nil {
			s.log.ErrorContext(ctx, "user: delete account objects", "user_id", u.ID, "prefix", prefix, "error", err)
		}
	}

	return nil
}

func (s *service) SetAvatar(ctx context.Context, userID uuid.UUID, f httpx.File) (MeResponse, error) {
	ext, err := avatarRule.Check(f)
	if err != nil {
		return MeResponse{}, err
	}

	prev, err := s.repo.FindByID(ctx, userID)
	if err != nil {
		return MeResponse{}, err
	}

	key := avatarPrefix(userID) + uuid.NewString() + ext
	if err := s.store.Put(ctx, s.bucket, key, f.Body, f.Size, f.ContentType); err != nil {
		return MeResponse{}, err
	}

	u, err := s.repo.UpdateAvatarKey(ctx, userID, &key)
	if err != nil {
		s.deleteObject(ctx, key)
		return MeResponse{}, err
	}

	if prev.AvatarKey != nil {
		s.deleteObject(ctx, *prev.AvatarKey)
	}

	return s.toMe(ctx, u)
}

func (s *service) DeleteAvatar(ctx context.Context, userID uuid.UUID) error {
	u, err := s.repo.FindByID(ctx, userID)
	if err != nil {
		return err
	}
	if u.AvatarKey == nil {
		return nil
	}

	if _, err := s.repo.UpdateAvatarKey(ctx, userID, nil); err != nil {
		return err
	}
	s.deleteObject(ctx, *u.AvatarKey)

	return nil
}

// toMe loads the role, its permissions and a presigned avatar URL for u.
func (s *service) toMe(ctx context.Context, u *User) (MeResponse, error) {
	role, err := s.roles.GetRole(ctx, u.RoleID)
	if err != nil {
		return MeResponse{}, err
	}

	perms, err := s.roles.PermissionCodes(ctx, u.RoleID)
	if err != nil {
		return MeResponse{}, err
	}

	var avatarURL *string
	if u.AvatarKey != nil {
		url, err := s.store.PresignGet(ctx, s.bucket, *u.AvatarKey, AvatarURLExpiresIn)
		if err != nil {
			return MeResponse{}, err
		}
		avatarURL = &url
	}

	return ToMeResponse(u, role, perms, avatarURL), nil
}

// deleteObject removes an object that is no longer referenced. A failure only
// leaves an orphan, so it is logged instead of failing the request.
func (s *service) deleteObject(ctx context.Context, key string) {
	if err := s.store.Delete(ctx, s.bucket, key); err != nil {
		s.log.ErrorContext(ctx, "user: delete object", "key", key, "error", err)
	}
}

func avatarPrefix(userID uuid.UUID) string  { return "avatars/" + userID.String() + "/" }
func receiptPrefix(userID uuid.UUID) string { return "receipts/" + userID.String() + "/" }
