# # syntax=docker/dockerfile:1.7

# ── Stage 1: Build ────────────────────────────────────────────
FROM rust:1.93-slim AS builder

WORKDIR /app

# Install build dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

# 1. Copy manifests to cache dependencies
COPY Cargo.toml Cargo.lock ./
COPY crates/robot-kit/Cargo.toml crates/robot-kit/Cargo.toml
# Create dummy targets declared in Cargo.toml so manifest parsing succeeds.
RUN mkdir -p src benches crates/robot-kit/src \
    && echo "fn main() {}" > src/main.rs \
    && echo "fn main() {}" > benches/agent_benchmarks.rs \
    && echo "pub fn placeholder() {}" > crates/robot-kit/src/lib.rs
RUN --mount=type=cache,id=openbnc-cargo-registry,target=/usr/local/cargo/registry,sharing=locked \
    --mount=type=cache,id=openbnc-cargo-git,target=/usr/local/cargo/git,sharing=locked \
    --mount=type=cache,id=openbnc-target,target=/app/target,sharing=locked \
    cargo build --release --locked
RUN rm -rf src benches crates/robot-kit/src

# 2. Copy only build-relevant source paths (avoid cache-busting on docs/tests/scripts)
COPY src/ src/
COPY benches/ benches/
COPY crates/ crates/
COPY firmware/ firmware/
COPY web/ web/
# Keep release builds resilient when frontend dist assets are not prebuilt in Git.
RUN mkdir -p web/dist && \
    if [ ! -f web/dist/index.html ]; then \
      printf '%s\n' \
        '<!doctype html>' \
        '<html lang="en">' \
        '  <head>' \
        '    <meta charset="utf-8" />' \
        '    <meta name="viewport" content="width=device-width,initial-scale=1" />' \
        '    <title>openbnc Dashboard</title>' \
        '  </head>' \
        '  <body>' \
        '    <h1>openbnc Dashboard Unavailable</h1>' \
        '    <p>Frontend assets are not bundled in this build. Build the web UI to populate <code>web/dist</code>.</p>' \
        '  </body>' \
        '</html>' > web/dist/index.html; \
    fi
RUN --mount=type=cache,id=openbnc-cargo-registry,target=/usr/local/cargo/registry,sharing=locked \
    --mount=type=cache,id=openbnc-cargo-git,target=/usr/local/cargo/git,sharing=locked \
    --mount=type=cache,id=openbnc-target,target=/app/target,sharing=locked \
    cargo build --release --locked && \
    cp target/release/openbnc /app/openbnc && \
    strip /app/openbnc

# Prepare runtime directory structure and default config inline (no extra stage)
RUN mkdir -p /openbnc-data/.openbnc /openbnc-data/workspace && \
    cat > /openbnc-data/.openbnc/config.toml <<EOF && \
    chown -R 65534:65534 /openbnc-data
workspace_dir = "/openbnc-data/workspace"
config_path = "/openbnc-data/.openbnc/config.toml"
api_key = ""
default_provider = "openrouter"
default_model = "anthropic/claude-sonnet-4-20250514"
default_temperature = 0.7

[gateway]
port = 42617
host = "[::]"
allow_public_bind = true
EOF

# ── Stage 2: Development Runtime (Debian) ────────────────────
FROM debian:bookworm-slim AS dev

# Install essential runtime dependencies only (use docker-compose.override.yml for dev tools)
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /openbnc-data /openbnc-data
COPY --from=builder /app/openbnc /usr/local/bin/openbnc

# Overwrite minimal config with DEV template (Ollama defaults)
COPY dev/config.template.toml /openbnc-data/.openbnc/config.toml
RUN chown 65534:65534 /openbnc-data/.openbnc/config.toml

# Environment setup
ENV OPENBNC_WORKSPACE=/openbnc-data/workspace
ENV HOME=/openbnc-data
# Defaults for local dev (Ollama) - matches config.template.toml
ENV PROVIDER="ollama"
ENV OPENBNC_MODEL="llama3.2"
ENV OPENBNC_GATEWAY_PORT=42617

# Note: API_KEY is intentionally NOT set here to avoid confusion.
# It is set in config.toml as the Ollama URL.

WORKDIR /openbnc-data
USER 65534:65534
EXPOSE 42617
ENTRYPOINT ["openbnc"]
CMD ["gateway"]

# ── Stage 3: Production Runtime (Distroless) ─────────────────
FROM gcr.io/distroless/cc-debian13:nonroot@sha256:84fcd3c223b144b0cb6edc5ecc75641819842a9679a3a58fd6294bec47532bf7 AS release

COPY --from=builder /app/openbnc /usr/local/bin/openbnc
COPY --from=builder /openbnc-data /openbnc-data

# Environment setup
ENV OPENBNC_WORKSPACE=/openbnc-data/workspace
ENV HOME=/openbnc-data
# Default provider and model are set in config.toml, not here,
# so config file edits are not silently overridden
#ENV PROVIDER=
ENV OPENBNC_GATEWAY_PORT=42617

# API_KEY must be provided at runtime!

WORKDIR /openbnc-data
USER 65534:65534
EXPOSE 42617
ENTRYPOINT ["openbnc"]
CMD ["gateway"]
