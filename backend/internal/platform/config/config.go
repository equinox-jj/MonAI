package config

import (
	"errors"
	"os"
)

// Config holds settings loaded from environment variables.
type Config struct {
	Env         string
	HTTPAddr    string
	DatabaseURL string
}

// Load reads the config from the environment.
func Load() (Config, error) {
	cfg := Config{
		Env:         getenv("APP_ENV", "development"),
		HTTPAddr:    getenv("HTTP_ADDR", ":8080"),
		DatabaseURL: os.Getenv("DATABASE_URL"),
	}
	if cfg.DatabaseURL == "" {
		return Config{}, errors.New("config: DATABASE_URL is required")
	}
	return cfg, nil
}

func getenv(key, fallback string) string {
	if v, ok := os.LookupEnv(key); ok && v != "" {
		return v
	}
	return fallback
}
