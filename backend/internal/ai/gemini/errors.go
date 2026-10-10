package gemini

import (
	"context"
	"errors"
	"fmt"
	"net/http"

	"google.golang.org/genai"

	"github.com/equinox-jj/MonAI/backend/internal/ai"
)

// classify wraps provider-side failures in ai.ErrUnavailable so the client
// falls back to its local parser. It keeps only the status code, since the
// API's message may echo the request.
func classify(err error) error {
	var apiErr genai.APIError
	switch {
	case errors.As(err, &apiErr):
		if apiErr.Code == http.StatusTooManyRequests || apiErr.Code >= http.StatusInternalServerError {
			return fmt.Errorf("gemini: status %d: %w", apiErr.Code, ai.ErrUnavailable)
		}
		// 4xx other than 429: a bad key, model name or schema, which is ours to fix.
		return fmt.Errorf("gemini: status %d (%s)", apiErr.Code, apiErr.Status)
	case errors.Is(err, context.DeadlineExceeded):
		return fmt.Errorf("gemini: timeout: %w", ai.ErrUnavailable)
	case errors.Is(err, context.Canceled):
		return fmt.Errorf("gemini: canceled: %w", err)
	default:
		// Network errors and the like; only the type, since the message can
		// contain the request URL.
		return fmt.Errorf("gemini: request (%T): %w", err, ai.ErrUnavailable)
	}
}

// blockReason explains an empty response, such as a safety block.
func blockReason(resp *genai.GenerateContentResponse) string {
	if resp.PromptFeedback != nil && resp.PromptFeedback.BlockReason != "" {
		return string(resp.PromptFeedback.BlockReason)
	}
	if len(resp.Candidates) > 0 {
		return string(resp.Candidates[0].FinishReason)
	}

	return ""
}
