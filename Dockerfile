FROM --platform=$BUILDPLATFORM golang:1.25.5-alpine3.23 AS build

WORKDIR /app

RUN apk add --no-cache git curl jq

ARG GOOSE_VERSION=latest

RUN if [ "$GOOSE_VERSION" = "latest" ]; then \
        REAL_GOOSE_VERSION=$(curl -s https://api.github.com/repos/pressly/goose/releases/latest | jq -r .tag_name); \
    else \
        REAL_GOOSE_VERSION=$GOOSE_VERSION; \
    fi && \
    echo $REAL_GOOSE_VERSION > /app/version.txt

RUN REAL_GOOSE_VERSION=$(cat /app/version.txt) && \
    echo "Building goose version: $REAL_GOOSE_VERSION" && \
    git clone --branch $REAL_GOOSE_VERSION --depth 1 --single-branch https://github.com/pressly/goose ./goose

WORKDIR /app/goose

ARG TARGETOS TARGETARCH

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -ldflags="-s" -o goose ./cmd/goose

FROM scratch

COPY --from=build /app/goose/LICENSE /licenses/goose_LICENSE

COPY --from=build /app/goose/goose /goose

ENV GOOSE_MIGRATION_DIR=/migrations

ENTRYPOINT ["/goose"]