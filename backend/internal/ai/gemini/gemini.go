// Package gemini implements ai.TransactionParser with Google's Gemini API.
package gemini

import (
	"context"
	"encoding/json"
	"fmt"
	"log/slog"
	"time"

	"google.golang.org/genai"

	"github.com/equinox-jj/MonAI/backend/internal/ai"
	"github.com/equinox-jj/MonAI/backend/internal/platform/config"
)

type parser struct {
	models *genai.Models
	model  string
	log    *slog.Logger
}

// New returns a Gemini parser, or one that always fails with
// ai.ErrUnavailable when GEMINI_API_KEY is empty, so the API still starts.
func New(cfg config.Config, log *slog.Logger) (ai.TransactionParser, error) {
	if cfg.Gemini.APIKey == "" {
		log.Warn("gemini: GEMINI_API_KEY is empty, AI endpoints are disabled")
		return disabled{}, nil
	}

	client, err := genai.NewClient(context.Background(), &genai.ClientConfig{
		APIKey:  cfg.Gemini.APIKey,
		Backend: genai.BackendGeminiAPI,
	})
	if err != nil {
		return nil, fmt.Errorf("gemini: new client: %w", err)
	}

	return &parser{models: client.Models, model: cfg.Gemini.Model, log: log}, nil
}

func (p *parser) ParseTransaction(ctx context.Context, in ai.ParseInput) ([]ai.RawDraft, error) {
	var resp transactionResponse
	if err := p.generate(ctx, "parse_transaction", transactionInstruction, transactionSchema(in), in, &resp); err != nil {
		return nil, err
	}

	return resp.toRaw(), nil
}

func (p *parser) ParseReceipt(ctx context.Context, in ai.ParseInput) (ai.RawReceiptDraft, error) {
	var resp receiptResponse
	if err := p.generate(ctx, "parse_receipt", receiptInstruction, receiptSchema(in), in, &resp); err != nil {
		return ai.RawReceiptDraft{}, err
	}

	return resp.toRaw(), nil
}

// generate asks for JSON matching schema and decodes it into out. It logs the
// operation, outcome and latency only, never the user's text or the output.
func (p *parser) generate(ctx context.Context, op, instruction string, schema *genai.Schema, in ai.ParseInput, out any) error {
	prompt, err := userPrompt(in)
	if err != nil {
		return fmt.Errorf("gemini: build prompt: %w", err)
	}

	start := time.Now()
	resp, err := p.models.GenerateContent(ctx, p.model,
		[]*genai.Content{genai.NewContentFromText(prompt, genai.RoleUser)},
		&genai.GenerateContentConfig{
			SystemInstruction: genai.NewContentFromText(instruction, genai.RoleUser),
			ResponseMIMEType:  "application/json",
			ResponseSchema:    schema,
		},
	)
	latency := time.Since(start)
	if err != nil {
		err = classify(err)
		p.log.WarnContext(ctx, "gemini: request failed", "op", op, "latency", latency, "error", err)
		return err
	}

	text := resp.Text()
	if text == "" {
		p.log.WarnContext(ctx, "gemini: empty response", "op", op, "latency", latency, "block_reason", blockReason(resp))
		return fmt.Errorf("gemini: empty response: %w", ai.ErrUnavailable)
	}
	if err := json.Unmarshal([]byte(text), out); err != nil {
		p.log.WarnContext(ctx, "gemini: invalid JSON", "op", op, "latency", latency)
		return fmt.Errorf("gemini: decode response: %w", ai.ErrUnavailable)
	}

	p.log.DebugContext(ctx, "gemini: ok", "op", op, "latency", latency)

	return nil
}

// disabled is the parser used without an API key.
type disabled struct{}

func (disabled) ParseTransaction(context.Context, ai.ParseInput) ([]ai.RawDraft, error) {
	return nil, fmt.Errorf("gemini: no API key: %w", ai.ErrUnavailable)
}

func (disabled) ParseReceipt(context.Context, ai.ParseInput) (ai.RawReceiptDraft, error) {
	return ai.RawReceiptDraft{}, fmt.Errorf("gemini: no API key: %w", ai.ErrUnavailable)
}
