package config

import (
	"errors"
	"fmt"
	"io/fs"
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
}

// Postgres holds database settings.
type Postgres struct {
	Port        string // POSTGRES_PORT
	DB          string // POSTGRES_DB
	User        string // POSTGRES_USER
	Password    string // POSTGRES_PASSWORD
	DatabaseURL string // DATABASE_URL
}

// MinIO holds object storage settings.
type MinIO struct {
	APIPort       string // MINIO_API_PORT
	ConsolePort   string // MINIO_CONSOLE_PORT
	RootUser      string // MINIO_ROOT_USER
	RootPassword  string // MINIO_ROOT_PASSWORD
	Endpoint      string // MINIO_ENDPOINT
	BucketPrivate string // MINIO_BUCKET_PRIVATE
	BucketPublic  string // MINIO_BUCKET_PUBLIC
}

// JWT holds access token settings.
type JWT struct {
	Secret    string        // JWT_SECRET
	Issuer    string        // JWT_ISSUER
	AccessTTL time.Duration // JWT_ACCESS_TTL
}

// Gemini holds AI provider settings.
type Gemini struct {
	APIKey string // GEMINI_API_KEY
	Model  string // GEMINI_MODEL
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

	if err := v.ReadInConfig(); err != nil && !errors.Is(err, fs.ErrNotExist) {
		return Config{}, fmt.Errorf("config: read .env: %w", err)
	}

	accessTTL, err := time.ParseDuration(v.GetString("JWT_ACCESS_TTL"))
	if err != nil {
		return Config{}, fmt.Errorf("config: invalid JWT_ACCESS_TTL: %w", err)
	}

	cfg := Config{
		App: App{
			Env:  v.GetString("APP_ENV"),
			Port: v.GetString("API_PORT"),
		},
		Postgres: Postgres{
			Port:        v.GetString("POSTGRES_PORT"),
			DB:          v.GetString("POSTGRES_DB"),
			User:        v.GetString("POSTGRES_USER"),
			Password:    v.GetString("POSTGRES_PASSWORD"),
			DatabaseURL: v.GetString("DATABASE_URL"),
		},
		MinIO: MinIO{
			APIPort:       v.GetString("MINIO_API_PORT"),
			ConsolePort:   v.GetString("MINIO_CONSOLE_PORT"),
			RootUser:      v.GetString("MINIO_ROOT_USER"),
			RootPassword:  v.GetString("MINIO_ROOT_PASSWORD"),
			Endpoint:      v.GetString("MINIO_ENDPOINT"),
			BucketPrivate: v.GetString("MINIO_BUCKET_PRIVATE"),
			BucketPublic:  v.GetString("MINIO_BUCKET_PUBLIC"),
		},
		JWT: JWT{
			Secret:    v.GetString("JWT_SECRET"),
			Issuer:    v.GetString("JWT_ISSUER"),
			AccessTTL: accessTTL,
		},
		Gemini: Gemini{
			APIKey: v.GetString("GEMINI_API_KEY"),
			Model:  v.GetString("GEMINI_MODEL"),
		},
	}
	if cfg.Postgres.DatabaseURL == "" {
		return Config{}, errors.New("config: DATABASE_URL is required")
	}
	if len(cfg.JWT.Secret) < 32 {
		return Config{}, errors.New("config: JWT_SECRET must be at least 32 characters")
	}
	if cfg.JWT.AccessTTL <= 0 {
		return Config{}, errors.New("config: JWT_ACCESS_TTL must be positive")
	}
	return cfg, nil
}
