# goose-docker

A minimal Docker wrapper for pressly/goose — a database migration tool for Go.

This repository provides a small Docker image that bundles the `goose` CLI so you can run migrations without installing Go or goose locally.

## Build the image

Build the `goose` image from the repository root:

```bash
# Build (latest) and tag as "goose"
docker build .

# Or specify a goose release tag
docker build --build-arg GOOSE_VERSION=v3.26.0 .
```

## Migrations directory

By default, migrations are expected in `/migrations`. Mount your host directory there using `-v $(pwd)/migrations:/migrations`. You can also override this path via the `-dir` flag or environment variables, ensuring behavior consistent with the official goose CLI.

## goose commands

Refer to the upstream project for the full reference: https://github.com/pressly/goose
