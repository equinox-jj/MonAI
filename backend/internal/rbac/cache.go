package rbac

import (
	"context"
	"strconv"
	"sync"
	"time"

	"golang.org/x/sync/singleflight"
)

// cacheEntry is one role's permission codes as loaded from the DB.
type cacheEntry struct {
	codes   []string            // sorted; shared, so callers must not modify it
	set     map[string]struct{} // codes, for membership checks
	expires time.Time
}

// loadFunc loads a role's permission codes from the DB.
type loadFunc func(ctx context.Context, roleID int64) ([]string, error)

// permissionCache keeps each role's permission codes in memory for ttl, so a
// role change takes effect within ttl without hitting the DB on every request.
// Concurrent misses for one role share a single load. Errors are not cached.
type permissionCache struct {
	ttl  time.Duration
	now  func() time.Time
	load loadFunc

	mu      sync.RWMutex
	entries map[int64]cacheEntry
	group   singleflight.Group
}

func newPermissionCache(ttl time.Duration, now func() time.Time, load loadFunc) *permissionCache {
	return &permissionCache{
		ttl:     ttl,
		now:     now,
		load:    load,
		entries: make(map[int64]cacheEntry),
	}
}

// get returns the role's entry, loading it when missing or expired.
func (c *permissionCache) get(ctx context.Context, roleID int64) (cacheEntry, error) {
	c.mu.RLock()
	e, ok := c.entries[roleID]
	c.mu.RUnlock()
	if ok && c.now().Before(e.expires) {
		return e, nil
	}

	v, err, _ := c.group.Do(strconv.FormatInt(roleID, 10), func() (any, error) {
		// The load is shared by every waiting caller, so one caller's
		// cancellation must not fail the others.
		codes, err := c.load(context.WithoutCancel(ctx), roleID)
		if err != nil {
			return cacheEntry{}, err
		}

		e := newCacheEntry(codes, c.now().Add(c.ttl))
		c.mu.Lock()
		c.entries[roleID] = e
		c.mu.Unlock()

		return e, nil
	})
	if err != nil {
		return cacheEntry{}, err
	}

	return v.(cacheEntry), nil
}

func newCacheEntry(codes []string, expires time.Time) cacheEntry {
	set := make(map[string]struct{}, len(codes))
	for _, code := range codes {
		set[code] = struct{}{}
	}

	return cacheEntry{codes: codes, set: set, expires: expires}
}
