# syntax=docker/dockerfile:1.4
ARG GO_VERSION=1.20.5
ARG ALPINE_VERSION=3.18
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}

ARG PROTOC_GEN_GO=v1.28.0
ARG PROTOC_GEN_GO_GRPC=v1.3.0

RUN apk update && \
    apk add --upgrade --no-cache \
        gcc libc-dev wget libstdc++ \
        protobuf protobuf-dev tzdata && \
    rm -rf /var/cache/apk/*

# Install Go tools (as in postCreateCommand)
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO} && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC}

WORKDIR /workspace
