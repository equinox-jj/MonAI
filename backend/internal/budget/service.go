package budget

import (
	"context"
	"time"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/period"
)

type Service interface {
	// Get returns the month's budget with its progress, or ErrNotFound.
	Get(ctx context.Context, userID uuid.UUID, month string) (BudgetResponse, error)
	// Set creates the month's budget or replaces its limit.
	Set(ctx context.Context, userID uuid.UUID, month string, req SetBudgetRequest) (BudgetResponse, error)
	// Delete removes the month's budget, or returns ErrNotFound.
	Delete(ctx context.Context, userID uuid.UUID, month string) error
}

type service struct {
	repo Repository
}

func NewService(repo Repository) Service {
	return &service{repo: repo}
}

// A malformed month in Get and Delete is 404, like a malformed path UUID
// (httpx.ParamUUID): it cannot match a budget.
func (s *service) Get(ctx context.Context, userID uuid.UUID, month string) (BudgetResponse, error) {
	from, to, err := period.Month(month)
	if err != nil {
		return BudgetResponse{}, ErrNotFound
	}

	b, err := s.repo.FindByMonth(ctx, userID, month)
	if err != nil {
		return BudgetResponse{}, err
	}

	return s.toResponse(ctx, b, from, to)
}

func (s *service) Set(ctx context.Context, userID uuid.UUID, month string, req SetBudgetRequest) (BudgetResponse, error) {
	from, to, err := period.Month(month)
	if err != nil {
		return BudgetResponse{}, ErrMonthInvalid
	}
	if req.LimitAmount < 1 {
		return BudgetResponse{}, ErrLimitInvalid
	}

	b := &Budget{UserID: userID, Month: month, LimitAmount: req.LimitAmount}
	if err := s.repo.Upsert(ctx, b); err != nil {
		return BudgetResponse{}, err
	}

	return s.toResponse(ctx, b, from, to)
}

func (s *service) Delete(ctx context.Context, userID uuid.UUID, month string) error {
	if _, _, err := period.Month(month); err != nil {
		return ErrNotFound
	}

	return s.repo.Delete(ctx, userID, month)
}

// toResponse maps b with the progress of its month [from, to).
func (s *service) toResponse(ctx context.Context, b *Budget, from, to time.Time) (BudgetResponse, error) {
	spent, err := s.repo.SpentBetween(ctx, b.UserID, from, to)
	if err != nil {
		return BudgetResponse{}, err
	}

	return ToBudgetResponse(b, spent), nil
}
