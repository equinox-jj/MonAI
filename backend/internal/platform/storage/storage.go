package storage

import (
	"context"
	"errors"
	"fmt"
	"io"
	"time"

	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
)

var ErrObjectNotFound = errors.New("storage: object not found")

// ObjectInfo describes a stored object.
type ObjectInfo struct {
	Size        int64
	ContentType string
}

// Storage is generic object storage. Key layout, size limits and allowed
// content types belong to the features that call it.
type Storage interface {
	// Put stores body (exactly size bytes) under key with the given content type.
	Put(ctx context.Context, bucket, key string, body io.Reader, size int64, contentType string) error
	PresignGet(ctx context.Context, bucket, key string, ttl time.Duration) (string, error)
	// Stat returns ErrObjectNotFound when the key does not exist.
	Stat(ctx context.Context, bucket, key string) (ObjectInfo, error)
	// Delete is idempotent: a missing key is not an error.
	Delete(ctx context.Context, bucket, key string) error
	// DeletePrefix removes every object under prefix (e.g. "receipts/{user_id}/").
	DeletePrefix(ctx context.Context, bucket, prefix string) error
	// PublicURL is the permanent URL of key in a public-read bucket.
	PublicURL(bucket, key string) string
	// Ping fails if MinIO is unreachable or a configured bucket is missing.
	Ping(ctx context.Context) error
}

type minioStorage struct {
	client    *minio.Client
	publicURL string
	buckets   []string
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

	s := &minioStorage{
		client:    client,
		publicURL: cfg.MinIO.PublicURL,
		buckets:   []string{cfg.MinIO.BucketPrivate, cfg.MinIO.BucketPublic},
	}
	lc.Append(fx.Hook{OnStart: s.Ping})

	return s, nil
}

func (s *minioStorage) Ping(ctx context.Context) error {
	for _, bucket := range s.buckets {
		ok, err := s.client.BucketExists(ctx, bucket)
		if err != nil {
			return fmt.Errorf("storage: check bucket %q: %w", bucket, err)
		}
		if !ok {
			return fmt.Errorf("storage: bucket %q does not exist", bucket)
		}
	}
	return nil
}

func (s *minioStorage) Put(ctx context.Context, bucket, key string, body io.Reader, size int64, contentType string) error {
	_, err := s.client.PutObject(ctx, bucket, key, body, size, minio.PutObjectOptions{ContentType: contentType})
	return err
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

func (s *minioStorage) PublicURL(bucket, key string) string {
	return s.publicURL + "/" + bucket + "/" + key
}
