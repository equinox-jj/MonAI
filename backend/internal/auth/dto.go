package auth

import "github.com/equinox-jj/MonAI/backend/internal/user"

// TokenTypeBearer is the only token_type the API issues.
const TokenTypeBearer = "Bearer"

// ---------------------------------------------------------------- Requests

// RegisterRequest is the body of POST /auth/register. Passwords are capped at
// 72 bytes (maxbytes, not max, which counts characters), bcrypt's input limit.
type RegisterRequest struct {
	Name     string `json:"name" validate:"required,min=1,notblank,max=100"`
	Email    string `json:"email" validate:"required,email,max=254"`
	Password string `json:"password" validate:"required,min=8,maxbytes=72"`
}

// LoginRequest is the body of POST /auth/login. The password has no minimum,
// so a short one fails like any wrong password (invalid_credentials).
type LoginRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required,maxbytes=72"`
}

// ChangePasswordRequest is the body of PUT /auth/password.
type ChangePasswordRequest struct {
	CurrentPassword string `json:"current_password" validate:"required"`
	NewPassword     string `json:"new_password" validate:"required,min=8,maxbytes=72,nefield=CurrentPassword"`
}

// ---------------------------------------------------------------- Responses

// AuthResponse is the data of register and login.
type AuthResponse struct {
	AccessToken string          `json:"access_token"`
	TokenType   string          `json:"token_type"` // always Bearer
	ExpiresIn   int64           `json:"expires_in"` // seconds
	User        user.MeResponse `json:"user"`
}
