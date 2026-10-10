package main

import (
	"go.uber.org/fx"

	"github.com/equinox-jj/MonAI/backend/internal/ai"
	"github.com/equinox-jj/MonAI/backend/internal/ai/gemini"
	"github.com/equinox-jj/MonAI/backend/internal/auth"
	"github.com/equinox-jj/MonAI/backend/internal/budget"
	"github.com/equinox-jj/MonAI/backend/internal/category"
	"github.com/equinox-jj/MonAI/backend/internal/health"
	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
	"github.com/equinox-jj/MonAI/backend/internal/platform/database"
	"github.com/equinox-jj/MonAI/backend/internal/platform/httpx"
	"github.com/equinox-jj/MonAI/backend/internal/platform/logger"
	"github.com/equinox-jj/MonAI/backend/internal/platform/security"
	"github.com/equinox-jj/MonAI/backend/internal/platform/storage"
	"github.com/equinox-jj/MonAI/backend/internal/provider"
	"github.com/equinox-jj/MonAI/backend/internal/rbac"
	"github.com/equinox-jj/MonAI/backend/internal/report"
	"github.com/equinox-jj/MonAI/backend/internal/transaction"
	"github.com/equinox-jj/MonAI/backend/internal/user"
	"github.com/equinox-jj/MonAI/backend/internal/wallet"
)

func main() {
	fx.New(options()).Run()
}

// options is the full dependency graph, shared with main_test.go.
func options() fx.Option {
	return fx.Options(
		logger.FxLogger,

		// Platform
		config.Module,
		logger.Module,
		database.Module,
		security.Module,
		storage.Module,
		httpx.Module,

		// Features
		health.Module,
		rbac.Module,
		auth.Module,
		user.Module,
		wallet.Module,
		category.Module,
		transaction.Module,
		budget.Module,
		report.Module,
		provider.Module,
		gemini.Module,
		ai.Module,
	)
}
