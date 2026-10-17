// Package period holds calendar range helpers.
package period

import (
	"sync"
	"time"
)

// MonthLayout is the API's YYYY-MM month format.
const MonthLayout = "2006-01"

// Month returns the half-open date range [from, to) of a YYYY-MM month, at
// UTC midnight so it compares with DATE values.
func Month(month string) (from, to time.Time, err error) {
	from, err = time.Parse(MonthLayout, month)
	if err != nil {
		return time.Time{}, time.Time{}, err
	}

	return from, from.AddDate(0, 1, 0), nil
}

// LocalDate returns t's calendar date in loc at UTC midnight, so it compares
// with DATE values.
func LocalDate(t time.Time, loc *time.Location) time.Time {
	y, m, d := t.In(loc).Date()
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
}

// Locations loads IANA locations and keeps them, since time.LoadLocation
// reads the tz database on every call. The zero value is ready to use.
type Locations struct {
	cache sync.Map // name → *time.Location
}

// Load returns the location for an IANA name such as "Asia/Makassar".
func (l *Locations) Load(name string) (*time.Location, error) {
	if loc, ok := l.cache.Load(name); ok {
		return loc.(*time.Location), nil
	}

	loc, err := time.LoadLocation(name)
	if err != nil {
		return nil, err
	}
	l.cache.Store(name, loc)

	return loc, nil
}
