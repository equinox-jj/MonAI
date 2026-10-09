package user

import (
	"context"
	"errors"
	"log/slog"
	"strings"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/security"
	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
)

// avatarExtensions lists the allowed avatar content types and the file
// extension used in their object keys.
var avatarExtensions = map[string]string{
	"image/jpeg": ".jpg",
	"image/png":  ".png",
	"image/webp": ".webp",
}

type Service interface {
	GetMe(ctx context.Context, userID uuid.UUID) (MeResponse, error)
	UpdateMe(ctx context.Context, userID uuid.UUID, req UpdateMeRequest) (MeResponse, error)
	// DeleteAccount checks the password, deletes the user (their data cascades
	// in the DB) and then removes their avatar and receipt objects.
	DeleteAccount(ctx context.Context, userID uuid.UUID, req DeleteAccountRequest) error
	CreateAvatarUploadURL(ctx context.Context, userID uuid.UUID, req AvatarUploadURLRequest) (UploadURLResponse, error)
	// ConfirmAvatar checks the uploaded object, saves it on the user and
	// deletes the previous avatar.
	ConfirmAvatar(ctx context.Context, userID uuid.UUID, req ConfirmAvatarRequest) (MeResponse, error)
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

func (s *service) CreateAvatarUploadURL(ctx context.Context, userID uuid.UUID, req AvatarUploadURLRequest) (UploadURLResponse, error) {
	ext, ok := avatarExtensions[req.ContentType]
	if !ok {
		return UploadURLResponse{}, ErrAvatarType
	}

	key := avatarPrefix(userID) + uuid.NewString() + ext
	url, err := s.store.PresignPut(ctx, s.bucket, key, AvatarURLExpiresIn)
	if err != nil {
		return UploadURLResponse{}, err
	}

	return ToUploadURLResponse(url, key, req.ContentType, AvatarURLExpiresIn), nil
}

func (s *service) ConfirmAvatar(ctx context.Context, userID uuid.UUID, req ConfirmAvatarRequest) (MeResponse, error) {
	key := req.ObjectKey
	if !isOwnAvatarKey(userID, key) {
		return MeResponse{}, ErrAvatarKeyInvalid
	}

	if err := s.checkAvatarObject(ctx, key); err != nil {
		return MeResponse{}, err
	}

	prev, err := s.repo.FindByID(ctx, userID)
	if err != nil {
		return MeResponse{}, err
	}

	u, err := s.repo.UpdateAvatarKey(ctx, userID, &key)
	if err != nil {
		return MeResponse{}, err
	}

	if prev.AvatarKey != nil && *prev.AvatarKey != key {
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

// checkAvatarObject verifies the uploaded object's type and size. A rejected
// object is deleted so it does not linger in the bucket.
func (s *service) checkAvatarObject(ctx context.Context, key string) error {
	info, err := s.store.Stat(ctx, s.bucket, key)
	if errors.Is(err, storage.ErrObjectNotFound) {
		return ErrAvatarNotFound
	}
	if err != nil {
		return err
	}

	var reject error
	if _, ok := avatarExtensions[info.ContentType]; !ok {
		reject = ErrAvatarType
	} else if info.Size > AvatarMaxSizeBytes {
		reject = ErrAvatarTooLarge
	}
	if reject != nil {
		s.deleteObject(ctx, key)
	}

	return reject
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

// isOwnAvatarKey reports whether key is a single object directly under the
// user's avatar prefix, rejecting path tricks such as "..".
func isOwnAvatarKey(userID uuid.UUID, key string) bool {
	name, ok := strings.CutPrefix(key, avatarPrefix(userID))
	return ok && name != "" && !strings.ContainsAny(name, "/\\") && name != "." && name != ".."
}
