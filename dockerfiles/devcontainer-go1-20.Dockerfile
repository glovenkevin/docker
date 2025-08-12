# syntax=docker/dockerfile:1.4
ARG GO_VERSION=1.20.5
ARG ALPINE_VERSION=3.18
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}

ARG PROTOC_GEN_GO=v1.28.0
ARG PROTOC_GEN_GO_GRPC=v1.3.0
ARG GOLANGCI_LINT=v1.55.2
ARG MOCKERY=v2.38.0
ARG GOSWAGGER=v0.30.5
ARG GOPLS=v0.15.3
ARG DLV=v1.22.1

# Install common utilities, zsh, git, and protobuf-compiler
RUN apk update && \
    apk add --no-cache \
        git bash make wget curl \
        libstdc++ sudo openssh-client \
        protobuf protobuf-dev tzdata \
        zsh shadow && \
    rm -rf /var/cache/apk/*

# Install Go tools (as in postCreateCommand)
RUN --mount=type=cache,target=/go/pkg/mod --mount=type=cache,target=/root/.cache/go-build \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO} && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC}

RUN --mount=type=cache,target=/go/pkg/mod --mount=type=cache,target=/root/.cache/go-build \
    go install golang.org/x/tools/gopls@${GOPLS} && \
    go install github.com/go-delve/delve/cmd/dlv@${DLV} && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@${GOLANGCI_LINT} && \
    go install github.com/vektra/mockery/v2@${MOCKERY} && \
    go install github.com/go-swagger/go-swagger/cmd/swagger@${GOSWAGGER}

# Set user
RUN addgroup -S -g 1000 vscode && adduser -S -u 1000 vscode -G vscode -s /bin/zsh && \
    install -d -o vscode -g vscode /workspace /home/vscode && \
    chown -R vscode:vscode /go && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode

# Setup Oh-my-zsh for vscode user
USER vscode
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configure zsh for vscode user
RUN echo 'ZSH_THEME="agnoster"' >> /home/vscode/.zshrc && \
    echo 'plugins=(git zsh-syntax-highlighting)' >> /home/vscode/.zshrc

# Setup zsh for vscode user
COPY --chown=vscode:vscode ./configs/example.gitconfig /home/vscode/.gitconfig
COPY --chown=vscode:vscode ./configs/example.cursorignore /home/vscode/.cursorignore
COPY --chown=vscode:vscode ./configs/example.gitignore /home/vscode/.gitignore_global

WORKDIR /workspace
SHELL ["/bin/zsh", "-c"]
