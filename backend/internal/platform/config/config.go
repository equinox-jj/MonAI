package config

import (
	"errors"
	"fmt"
	"io/fs"
	"strings"
	"time"

	"github.com/spf13/viper"
)

// Config holds the settings defined in .env.
type Config struct {
	App      App
	Postgres Postgres
	MinIO    MinIO
	JWT      JWT
	Gemini   Gemini
}

// App holds general application settings.
type App struct {
	Env  string // APP_ENV
	Port string // API_PORT
	// TrustedProxies are the reverse proxy IPs or CIDRs whose X-Forwarded-For
	// header is trusted for the client IP. Empty means the connecting IP.
	TrustedProxies []string // TRUSTED_PROXIES, comma-separated
}

// Postgres holds database settings.
type Postgres struct {
	Port        string // POSTGRES_PORT
	DB          string // POSTGRES_DB
	User        string // POSTGRES_USER
	Password    string // POSTGRES_PASSWORD
	DatabaseURL string // DATABASE_URL

	MaxOpenConns    int           // DB_MAX_OPEN_CONNS
	MaxIdleConns    int           // DB_MAX_IDLE_CONNS
	ConnMaxLifetime time.Duration // DB_CONN_MAX_LIFETIME
}

// MinIO holds object storage settings.
type MinIO struct {
	APIPort      string // MINIO_API_PORT
	ConsolePort  string // MINIO_CONSOLE_PORT
	RootUser     string // MINIO_ROOT_USER
	RootPassword string // MINIO_ROOT_PASSWORD
	// AccessKey and SecretKey are the API's own credentials, limited to the
	// two buckets (created by minio-init). Outside production they fall back
	// to the root credentials when unset.
	AccessKey     string // MINIO_ACCESS_KEY
	SecretKey     string // MINIO_SECRET_KEY
	Endpoint      string // MINIO_ENDPOINT
	UseSSL        bool   // MINIO_USE_SSL
	BucketPrivate string // MINIO_BUCKET_PRIVATE
	BucketPublic  string // MINIO_BUCKET_PUBLIC
	// PublicURL is the base URL clients read the public bucket from. It
	// defaults to MINIO_ENDPOINT with the scheme from MINIO_USE_SSL.
	PublicURL string // MINIO_PUBLIC_URL
}

// JWT holds access token settings.
type JWT struct {
	Secret    string        // JWT_SECRET
	Issuer    string        // JWT_ISSUER
	AccessTTL time.Duration // JWT_ACCESS_TTL
}

// Gemini holds AI provider settings.
// An empty APIKey disables the AI endpoints (503 ai_unavailable).
type Gemini struct {
	APIKey  string        // GEMINI_API_KEY
	Model   string        // GEMINI_MODEL
	Timeout time.Duration // GEMINI_TIMEOUT
}

// Load reads the config with Viper. Precedence is env vars, then a .env file
// in the working directory, then defaults, so real env vars (for example
// docker compose's DATABASE_URL) win. Empty env vars count as unset.
func Load() (Config, error) {
	v := viper.New()
	v.SetConfigFile(".env")
	v.SetConfigType("env")
	v.AutomaticEnv()

	v.SetDefault("APP_ENV", "development")
	v.SetDefault("API_PORT", "8080")
	v.SetDefault("MINIO_USE_SSL", false)
	v.SetDefault("GEMINI_MODEL", "gemini-flash-lite-latest")
	v.SetDefault("GEMINI_TIMEOUT", "10s")
	v.SetDefault("DB_MAX_OPEN_CONNS", 20)
	v.SetDefault("DB_MAX_IDLE_CONNS", 10)
	v.SetDefault("DB_CONN_MAX_LIFETIME", "30m")

	if err := v.ReadInConfig(); err != nil && !errors.Is(err, fs.ErrNotExist) {
		return Config{}, fmt.Errorf("config: read .env: %w", err)
	}

	accessTTL, err := time.ParseDuration(v.GetString("JWT_ACCESS_TTL"))
	if err != nil {
		return Config{}, fmt.Errorf("config: invalid JWT_ACCESS_TTL: %w", err)
	}
	geminiTimeout, err := time.ParseDuration(v.GetString("GEMINI_TIMEOUT"))
	if err != nil {
		return Config{}, fmt.Errorf("config: invalid GEMINI_TIMEOUT: %w", err)
	}
	connMaxLifetime, err := time.ParseDuration(v.GetString("DB_CONN_MAX_LIFETIME"))
	if err != nil {
		return Config{}, fmt.Errorf("config: invalid DB_CONN_MAX_LIFETIME: %w", err)
	}

	cfg := Config{
		App: App{
			Env:            v.GetString("APP_ENV"),
			Port:           v.GetString("API_PORT"),
			TrustedProxies: splitList(v.GetString("TRUSTED_PROXIES")),
		},
		Postgres: Postgres{
			Port:        v.GetString("POSTGRES_PORT"),
			DB:          v.GetString("POSTGRES_DB"),
			User:        v.GetString("POSTGRES_USER"),
			Password:    v.GetString("POSTGRES_PASSWORD"),
			DatabaseURL: v.GetString("DATABASE_URL"),

			MaxOpenConns:    v.GetInt("DB_MAX_OPEN_CONNS"),
			MaxIdleConns:    v.GetInt("DB_MAX_IDLE_CONNS"),
			ConnMaxLifetime: connMaxLifetime,
		},
		MinIO: MinIO{
			APIPort:       v.GetString("MINIO_API_PORT"),
			ConsolePort:   v.GetString("MINIO_CONSOLE_PORT"),
			RootUser:      v.GetString("MINIO_ROOT_USER"),
			RootPassword:  v.GetString("MINIO_ROOT_PASSWORD"),
			AccessKey:     v.GetString("MINIO_ACCESS_KEY"),
			SecretKey:     v.GetString("MINIO_SECRET_KEY"),
			Endpoint:      v.GetString("MINIO_ENDPOINT"),
			UseSSL:        v.GetBool("MINIO_USE_SSL"),
			BucketPrivate: v.GetString("MINIO_BUCKET_PRIVATE"),
			BucketPublic:  v.GetString("MINIO_BUCKET_PUBLIC"),
			PublicURL:     strings.TrimRight(v.GetString("MINIO_PUBLIC_URL"), "/"),
		},
		JWT: JWT{
			Secret:    v.GetString("JWT_SECRET"),
			Issuer:    v.GetString("JWT_ISSUER"),
			AccessTTL: accessTTL,
		},
		Gemini: Gemini{
			APIKey:  v.GetString("GEMINI_API_KEY"),
			Model:   v.GetString("GEMINI_MODEL"),
			Timeout: geminiTimeout,
		},
	}
	if cfg.Postgres.DatabaseURL == "" {
		return Config{}, errors.New("config: DATABASE_URL is required")
	}
	if cfg.Postgres.MaxOpenConns < 1 || cfg.Postgres.MaxIdleConns < 0 || cfg.Postgres.MaxIdleConns > cfg.Postgres.MaxOpenConns {
		return Config{}, errors.New("config: DB_MAX_OPEN_CONNS must be positive and DB_MAX_IDLE_CONNS between 0 and it")
	}
	if cfg.MinIO.Endpoint == "" {
		return Config{}, errors.New("config: MINIO_ENDPOINT is required")
	}
	if cfg.MinIO.AccessKey == "" || cfg.MinIO.SecretKey == "" {
		if cfg.App.Env == "production" {
			return Config{}, errors.New("config: MINIO_ACCESS_KEY and MINIO_SECRET_KEY are required in production; the API must not use the MinIO root credentials")
		}
		cfg.MinIO.AccessKey, cfg.MinIO.SecretKey = cfg.MinIO.RootUser, cfg.MinIO.RootPassword
	}
	if cfg.MinIO.AccessKey == "" || cfg.MinIO.SecretKey == "" {
		return Config{}, errors.New("config: set MINIO_ACCESS_KEY and MINIO_SECRET_KEY (or MINIO_ROOT_USER and MINIO_ROOT_PASSWORD outside production)")
	}
	if cfg.MinIO.BucketPrivate == "" || cfg.MinIO.BucketPublic == "" {
		return Config{}, errors.New("config: MINIO_BUCKET_PRIVATE and MINIO_BUCKET_PUBLIC are required")
	}
	if cfg.MinIO.PublicURL == "" {
		scheme := "http"
		if cfg.MinIO.UseSSL {
			scheme = "https"
		}
		cfg.MinIO.PublicURL = scheme + "://" + cfg.MinIO.Endpoint
	}
	if len(cfg.JWT.Secret) < 32 {
		return Config{}, errors.New("config: JWT_SECRET must be at least 32 characters")
	}
	if cfg.JWT.AccessTTL <= 0 {
		return Config{}, errors.New("config: JWT_ACCESS_TTL must be positive")
	}
	if cfg.Gemini.Timeout <= 0 {
		return Config{}, errors.New("config: GEMINI_TIMEOUT must be positive")
	}

	return cfg, nil
}

// splitList splits a comma-separated value, dropping blank items.
func splitList(v string) []string {
	var out []string
	for item := range strings.SplitSeq(v, ",") {
		if item = strings.TrimSpace(item); item != "" {
			out = append(out, item)
		}
	}
	return out
}
