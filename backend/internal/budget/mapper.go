package budget

import "math"

// ToBudgetResponse maps a budget with the amount spent in its month to the
// API shape.
func ToBudgetResponse(b *Budget, spent int64) BudgetResponse {
	percent, status := progress(b.LimitAmount, spent)

	return BudgetResponse{
		Month:           b.Month,
		LimitAmount:     b.LimitAmount,
		Spent:           spent,
		Remaining:       b.LimitAmount - spent,
		ProgressPercent: percent,
		Status:          status,
	}
}

// progress returns spent as a percentage of limit, rounded to one decimal,
// and the budget status. limit must be positive. The status uses integer
// math so rounding cannot move it across the 80% and 100% boundaries.
func progress(limit, spent int64) (float64, Status) {
	percent := math.Round(float64(spent)*1000/float64(limit)) / 10

	switch {
	case spent > limit:
		return percent, StatusExceeded
	case spent*5 >= limit*4:
		return percent, StatusWarning
	default:
		return percent, StatusOK
	}
}
