package gemini

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"

	"google.golang.org/genai"

	"github.com/equinox-jj/MonAI/backend/internal/ai"
)

// classify wraps provider-side failures in ai.ErrUnavailable so the client
// falls back to its local parser. The returned error keeps only the status
// code; the provider's message goes to the log alone (see providerMessage).
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

// retryDelay is the pause before the one retry of an overloaded or
// rate-limited request.
const retryDelay = time.Second

// maxProviderMessage caps the provider message kept in the log.
const maxProviderMessage = 200

// retryable reports whether err is worth one more try: the model is
// overloaded (503) or the request was rate-limited (429). Both are usually
// short-lived; other failures would fail again.
func retryable(err error) bool {
	var apiErr genai.APIError
	if !errors.As(err, &apiErr) {
		return false
	}

	return apiErr.Code == http.StatusServiceUnavailable || apiErr.Code == http.StatusTooManyRequests
}

// providerMessage is the API error's status and message on one short line,
// e.g. "UNAVAILABLE: This model is currently experiencing high demand.", or
// "" for errors that aren't API errors. It is for the log only.
func providerMessage(err error) string {
	var apiErr genai.APIError
	if !errors.As(err, &apiErr) {
		return ""
	}
	msg := strings.Join(strings.Fields(apiErr.Message), " ")
	if len(msg) > maxProviderMessage {
		msg = msg[:maxProviderMessage] + "…"
	}
	if apiErr.Status == "" {
		return msg
	}

	return apiErr.Status + ": " + msg
}

// withRetry runs call, and once more after delay when it fails with a
// retryable error, calling onRetry (if set) before waiting. It gives up
// without the retry when ctx ends first.
func withRetry[T any](ctx context.Context, delay time.Duration, call func() (T, error), onRetry func(error)) (T, error) {
	result, err := call()
	if err == nil || !retryable(err) {
		return result, err
	}
	if onRetry != nil {
		onRetry(err)
	}
	timer := time.NewTimer(delay)
	defer timer.Stop()
	select {
	case <-ctx.Done():
		return result, err
	case <-timer.C:
	}

	return call()
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
