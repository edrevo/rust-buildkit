# syntax = docker/dockerfile:1.1-experimental

FROM clux/muslrust:stable as builder
USER root

WORKDIR /rust-src
COPY . /rust-src

RUN --mount=type=cache,target=/rust-src/target \
    --mount=type=cache,target=/root/.cargo/git \
    --mount=type=cache,target=/root/.cargo/registry \
    ["cargo", "build", "--release", "--target", "x86_64-unknown-linux-musl", "--example", "reverse"]

RUN --mount=type=cache,target=/rust-src/target \
    ["cp", "/rust-src/target/x86_64-unknown-linux-musl/release/examples/reverse", "/usr/local/bin/reverse"]

FROM scratch
COPY --from=builder /usr/local/bin/reverse /usr/local/bin/reverse
ENTRYPOINT ["/usr/local/bin/reverse"]
