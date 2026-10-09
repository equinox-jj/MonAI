package storage

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
)

var ErrObjectNotFound = errors.New("storage: object not found")

// ObjectInfo is what features check when confirming an upload.
type ObjectInfo struct {
	Size        int64
	ContentType string
}

// Storage is generic object storage. Key layout, size limits and allowed
// content types belong to the features that call it.
type Storage interface {
	PresignPut(ctx context.Context, bucket, key string, ttl time.Duration) (string, error)
	PresignGet(ctx context.Context, bucket, key string, ttl time.Duration) (string, error)
	// Stat returns ErrObjectNotFound when the key does not exist.
	Stat(ctx context.Context, bucket, key string) (ObjectInfo, error)
	// Delete is idempotent: a missing key is not an error.
	Delete(ctx context.Context, bucket, key string) error
	// DeletePrefix removes every object under prefix (e.g. "receipts/{user_id}/").
	DeletePrefix(ctx context.Context, bucket, prefix string) error
}

type minioStorage struct {
	client *minio.Client
}

// New connects to MinIO and, on start, fails if a configured bucket is missing.
// The buckets are created by minio-init in docker-compose.yml.
func New(lc fx.Lifecycle, cfg config.Config) (Storage, error) {
	client, err := minio.New(cfg.MinIO.Endpoint, &minio.Options{
		Creds:  credentials.NewStaticV4(cfg.MinIO.RootUser, cfg.MinIO.RootPassword, ""),
		Secure: cfg.MinIO.UseSSL,
	})
	if err != nil {
		return nil, fmt.Errorf("storage: %w", err)
	}

	lc.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			for _, bucket := range []string{cfg.MinIO.BucketPrivate, cfg.MinIO.BucketPublic} {
				ok, err := client.BucketExists(ctx, bucket)
				if err != nil {
					return fmt.Errorf("storage: check bucket %q: %w", bucket, err)
				}
				if !ok {
					return fmt.Errorf("storage: bucket %q does not exist", bucket)
				}
			}
			return nil
		},
	})

	return &minioStorage{client: client}, nil
}

func (s *minioStorage) PresignPut(ctx context.Context, bucket, key string, ttl time.Duration) (string, error) {
	u, err := s.client.PresignedPutObject(ctx, bucket, key, ttl)
	if err != nil {
		return "", err
	}
	return u.String(), nil
}

func (s *minioStorage) PresignGet(ctx context.Context, bucket, key string, ttl time.Duration) (string, error) {
	u, err := s.client.PresignedGetObject(ctx, bucket, key, ttl, nil)
	if err != nil {
		return "", err
	}
	return u.String(), nil
}

func (s *minioStorage) Stat(ctx context.Context, bucket, key string) (ObjectInfo, error) {
	info, err := s.client.StatObject(ctx, bucket, key, minio.StatObjectOptions{})
	if err != nil {
		if minio.ToErrorResponse(err).Code == minio.NoSuchKey {
			return ObjectInfo{}, ErrObjectNotFound
		}
		return ObjectInfo{}, err
	}
	return ObjectInfo{Size: info.Size, ContentType: info.ContentType}, nil
}

func (s *minioStorage) Delete(ctx context.Context, bucket, key string) error {
	return s.client.RemoveObject(ctx, bucket, key, minio.RemoveObjectOptions{})
}

func (s *minioStorage) DeletePrefix(ctx context.Context, bucket, prefix string) error {
	// Cancelling on return stops the listing goroutine if removal fails early.
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	objects := s.client.ListObjects(ctx, bucket, minio.ListObjectsOptions{Prefix: prefix, Recursive: true})
	for res := range s.client.RemoveObjects(ctx, bucket, objects, minio.RemoveObjectsOptions{}) {
		if res.Err != nil {
			return fmt.Errorf("storage: remove %q: %w", res.ObjectName, res.Err)
		}
	}
	return nil
}
