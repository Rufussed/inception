# Tiny REST API Dockerfile (multi-stage, minimal, secure)
FROM debian:bullseye AS build

# Install Go and build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates git gcc build-essential && \
    rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://go.dev/dl/go1.22.4.linux-amd64.tar.gz -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /app
COPY main.go ./
RUN go build -ldflags="-s -w" -o tinyapi main.go

# Minimal runtime image
FROM debian:bullseye
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*
RUN useradd -m -d /home/tinyapi -s /bin/bash tinyapi
WORKDIR /opt/tinyapi
COPY --from=build /app/tinyapi ./
RUN chown -R tinyapi:tinyapi /opt/tinyapi
USER tinyapi
EXPOSE 8080
ENTRYPOINT ["/opt/tinyapi/tinyapi"]
