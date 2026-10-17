package category

import (
	"context"
	"errors"
	"strings"

	"github.com/google/uuid"

	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
)

// defaultCategories are created for every user on register (ERD §5). Icons
// are Material Symbols names and colors the light hex the app knows a dark
// variant for (CategoryColors on Android).
var defaultCategories = []Category{
	{Name: "Food", Type: TypeExpense, Icon: new("restaurant"), Color: new("#F97316"), IsDefault: true},
	{Name: "Transport", Type: TypeExpense, Icon: new("directions_car"), Color: new("#0EA5E9"), IsDefault: true},
	{Name: "Bills", Type: TypeExpense, Icon: new("receipt_long"), Color: new("#8B5CF6"), IsDefault: true},
	{Name: "Shopping", Type: TypeExpense, Icon: new("shopping_bag"), Color: new("#EC4899"), IsDefault: true},
	{Name: "Health", Type: TypeExpense, Icon: new("favorite"), Color: new("#10B981"), IsDefault: true},
	{Name: "Entertainment", Type: TypeExpense, Icon: new("movie"), Color: new("#F59E0B"), IsDefault: true},
	{Name: "Other", Type: TypeExpense, Icon: new("inventory_2"), Color: new("#64748B"), IsDefault: true, IsSystem: true},
	{Name: "Salary", Type: TypeIncome, Icon: new("payments"), Color: new("#14B8A6"), IsDefault: true},
	{Name: "Bonus", Type: TypeIncome, Icon: new("redeem"), Color: new("#84CC16"), IsDefault: true},
	{Name: "Other Income", Type: TypeIncome, Icon: new("savings"), Color: new("#6366F1"), IsDefault: true, IsSystem: true},
}

type Service interface {
	List(ctx context.Context, userID uuid.UUID, q ListCategoriesQuery) ([]CategoryResponse, error)
	Create(ctx context.Context, userID uuid.UUID, req CreateCategoryRequest) (CategoryResponse, error)
	// Update applies the fields present in req. System categories cannot be
	// hidden.
	Update(ctx context.Context, userID, id uuid.UUID, req UpdateCategoryRequest) (CategoryResponse, error)
	// Delete removes a custom category. If it has transactions, they are moved
	// to moveTo (same user and type) and the category deleted in one DB
	// transaction.
	Delete(ctx context.Context, userID, id uuid.UUID, moveTo *uuid.UUID) error
	// SeedDefaults creates the default categories for a new user. Call it
	// inside the register transaction.
	SeedDefaults(ctx context.Context, userID uuid.UUID) error
}

type service struct {
	repo Repository
	tx   database.TxManager
}

func NewService(repo Repository, tx database.TxManager) Service {
	return &service{repo: repo, tx: tx}
}

func (s *service) List(ctx context.Context, userID uuid.UUID, q ListCategoriesQuery) ([]CategoryResponse, error) {
	cs, err := s.repo.List(ctx, userID, ListFilter{Type: q.Type, IncludeHidden: q.IncludeHidden})
	if err != nil {
		return nil, err
	}

	return ToCategoryResponses(cs), nil
}

func (s *service) Create(ctx context.Context, userID uuid.UUID, req CreateCategoryRequest) (CategoryResponse, error) {
	cs := []Category{{
		UserID: userID,
		Name:   strings.TrimSpace(req.Name),
		Type:   req.Type,
		Icon:   req.Icon,
		Color:  req.Color,
	}}
	if err := s.repo.CreateMany(ctx, cs); err != nil {
		return CategoryResponse{}, err
	}

	return ToCategoryResponse(&cs[0]), nil
}

func (s *service) Update(ctx context.Context, userID, id uuid.UUID, req UpdateCategoryRequest) (CategoryResponse, error) {
	if req.empty() {
		return CategoryResponse{}, httpx.ErrNoFields
	}

	c, err := s.repo.FindByID(ctx, userID, id)
	if err != nil {
		return CategoryResponse{}, err
	}

	if req.Name != nil {
		c.Name = strings.TrimSpace(*req.Name)
	}
	if req.Icon.Set {
		c.Icon = req.Icon.Value
	}
	if req.Color.Set {
		c.Color = req.Color.Value
	}
	if req.IsHidden != nil {
		if *req.IsHidden && c.IsSystem {
			return CategoryResponse{}, ErrHideSystem
		}
		c.IsHidden = *req.IsHidden
	}

	if err := s.repo.Update(ctx, c); err != nil {
		return CategoryResponse{}, err
	}

	return ToCategoryResponse(c), nil
}

func (s *service) Delete(ctx context.Context, userID, id uuid.UUID, moveTo *uuid.UUID) error {
	return s.tx.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.repo.FindByID(ctx, userID, id)
		if err != nil {
			return err
		}
		if c.IsDefault || c.IsSystem {
			return ErrDeleteLocked
		}

		has, err := s.repo.HasTransactions(ctx, id)
		if err != nil {
			return err
		}
		if has {
			if moveTo == nil {
				return ErrHasTransactions
			}
			if err := s.checkMoveTarget(ctx, c, *moveTo); err != nil {
				return err
			}
			if err := s.repo.MoveTransactions(ctx, id, *moveTo); err != nil {
				return err
			}
		}

		return s.repo.Delete(ctx, userID, id)
	})
}

func (s *service) SeedDefaults(ctx context.Context, userID uuid.UUID) error {
	cs := make([]Category, len(defaultCategories))
	for i, d := range defaultCategories {
		d.UserID = userID
		cs[i] = d
	}

	return s.repo.CreateMany(ctx, cs)
}

// checkMoveTarget verifies that targetID is another category of the user
// with c's type. A missing target is a validation error, not a 404, so it is
// not confused with the category being deleted.
func (s *service) checkMoveTarget(ctx context.Context, c *Category, targetID uuid.UUID) error {
	if targetID == c.ID {
		return ErrMoveToInvalid
	}

	target, err := s.repo.FindByID(ctx, c.UserID, targetID)
	if errors.Is(err, ErrNotFound) {
		return ErrMoveToInvalid
	}
	if err != nil {
		return err
	}
	if target.Type != c.Type {
		return ErrMoveToInvalid
	}

	return nil
}
