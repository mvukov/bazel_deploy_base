FROM golang:latest AS golang-stage

WORKDIR /app

RUN wget https://raw.githubusercontent.com/buildbarn/bb-remote-execution/96c4fdce659fabfaba7ee2a60fd4e2ffab8352e2/cmd/fake_python/main.go

RUN go mod init fake_python \
    && CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o fake_python

FROM ubuntu:22.04 AS builder-stage

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt-get install -y --no-install-recommends \
    libatomic1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=golang-stage /app/fake_python /usr/bin/fake_python
RUN ln -s /usr/bin/fake_python /usr/bin/python3
