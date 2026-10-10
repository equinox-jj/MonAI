// Package period holds calendar range helpers.
package period

import "time"

// Month returns the half-open date range [from, to) of a YYYY-MM month, at
// UTC midnight so it compares with DATE values.
func Month(month string) (from, to time.Time, err error) {
	from, err = time.Parse("2006-01", month)
	if err != nil {
		return time.Time{}, time.Time{}, err
	}

	return from, from.AddDate(0, 1, 0), nil
}
