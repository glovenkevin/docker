FROM golang:1.23.4-bullseye

ARG EXPOSED_PORT=10000

# Install common utilities, zsh, Oh My Zsh, git, and protobuf-compiler
RUN apt-get update && \
    apt-get install -y \
        zsh \
        git \
        curl \
        wget \
        ca-certificates \
        unzip \
        htop \
        less \
        nano \
        sudo \
        lsb-release \
        procps \
        locales \
        openssh-client \
        gnupg \
        software-properties-common \
        protobuf-compiler && \
    # Install Oh My Zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true && \
    # Set zsh as default shell for root
    chsh -s $(which zsh) root && \
    # Clean up
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Go tools (as in postCreateCommand)
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.32.0 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0 && \
    go install golang.org/x/tools/gopls@v0.15.2 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.56.2 && \
    go install github.com/go-delve/delve/cmd/dlv@v1.22.1

# Set working directory
WORKDIR /workspace

# Expose port (as per forwardPorts)
EXPOSE $EXPOSED_PORT

# Set default user
USER root

# Default shell
SHELL ["/bin/zsh", "-c"]
