package storage

import (
	"strings"

	"github.com/google/uuid"
)

// Object key layout, shared by the features that write and clean up objects.
// Keys are {prefix}{owner_id}/{uuid}{ext}; size limits and allowed types
// belong to the features.
const (
	avatarsDir         = "avatars/"          // private bucket
	receiptsDir        = "receipts/"         // private bucket, attached to transactions
	pendingReceiptsDir = "receipts-pending/" // private bucket, expired by a lifecycle rule
	providerLogosDir   = "providers/"        // public bucket
)

// PendingReceiptsPrefix is where uploads wait until a transaction references
// them. minio-init expires objects here after a day (docker-compose.*.yml).
const PendingReceiptsPrefix = pendingReceiptsDir

func AvatarPrefix(userID uuid.UUID) string { return avatarsDir + userID.String() + "/" }

func ReceiptPrefix(userID uuid.UUID) string { return receiptsDir + userID.String() + "/" }

func PendingReceiptPrefix(userID uuid.UUID) string {
	return pendingReceiptsDir + userID.String() + "/"
}

func ProviderLogoPrefix(providerID uuid.UUID) string {
	return providerLogosDir + providerID.String() + "/"
}

// NewKey returns a fresh key under prefix with the given extension (".jpg").
func NewKey(prefix, ext string) string {
	return prefix + uuid.NewString() + ext
}

// ObjectName returns the part of key after prefix when key names a single
// object directly under prefix, rejecting nested paths and tricks such as "..".
func ObjectName(prefix, key string) (string, bool) {
	name, ok := strings.CutPrefix(key, prefix)
	if !ok || name == "" || name == "." || name == ".." || strings.ContainsAny(name, `/\`) {
		return "", false
	}
	return name, true
}
