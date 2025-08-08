# syntax=docker/dockerfile:1.4
FROM golang:1.20.5-alpine3.18

# Install common utilities, zsh, git, and protobuf-compiler
RUN apk update && \
    apk add --no-cache \
        git \
        zsh \
        bash \
        make \
        curl \
        libstdc++ \
        sudo \
        openssh-client \
        gnupg \
        protobuf && \
    # Clean up
    rm -rf /var/cache/apk/*

# Install Go tools (as in postCreateCommand)
RUN --mount=type=cache,target=/go/pkg/mod --mount=type=cache,target=/root/.cache/go-build \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.0 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0

RUN --mount=type=cache,target=/go/pkg/mod --mount=type=cache,target=/root/.cache/go-build \
    go install golang.org/x/tools/gopls@v0.15.3 && \
    go install github.com/go-delve/delve/cmd/dlv@v1.22.1 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.55.2 && \
    go install github.com/vektra/mockery/v2@v2.38.0

# Set working directory
WORKDIR /workspace

# Configure global git ignore for pb and vendor folders
RUN git config --global core.excludesfile ~/.gitignore_global && \
    echo "pb/" >> ~/.gitignore_global && \
    echo "vendor/" >> ~/.gitignore_global && \
    echo ".devcontainer/" >> ~/.gitignore_global

# Configure git to use SSH instead of HTTPS for GitHub
RUN git config --global url."ssh://git@work/".insteadOf https://github.com/

# Set default user
USER root

# Default shell
SHELL ["/bin/zsh", "-c"]
