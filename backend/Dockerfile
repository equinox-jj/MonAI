# syntax=docker/dockerfile:1

FROM golang:1.27-alpine AS build
WORKDIR /src

COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod go mod download

COPY . .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/ ./cmd/api ./cmd/migrate ./cmd/seed-admin

FROM gcr.io/distroless/static-debian12:nonroot
ENV TZ=UTC
# migrate and seed-admin ship alongside the API: the image has no shell or Go
# toolchain, so they are run as /migrate and /seed-admin.
COPY --from=build /out/api /out/migrate /out/seed-admin /
EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/api"]
