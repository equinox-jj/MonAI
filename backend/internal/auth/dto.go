package auth

import "github.com/equinox-jj/MonAI/backend/internal/user"

// TokenTypeBearer is the only token_type the API issues.
const TokenTypeBearer = "Bearer"

// ---------------------------------------------------------------- Requests

// RegisterRequest is the body of POST /auth/register. The password max is
// 72 bytes, bcrypt's input limit.
type RegisterRequest struct {
	Name     string `json:"name" validate:"required,min=1,max=100"`
	Email    string `json:"email" validate:"required,email,max=254"`
	Password string `json:"password" validate:"required,min=8,max=72"`
}

// LoginRequest is the body of POST /auth/login.
type LoginRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required"`
}

// ---------------------------------------------------------------- Responses

// AuthResponse is the data of register and login.
type AuthResponse struct {
	AccessToken string          `json:"access_token"`
	TokenType   string          `json:"token_type"` // always Bearer
	ExpiresIn   int64           `json:"expires_in"` // seconds
	User        user.MeResponse `json:"user"`
}
