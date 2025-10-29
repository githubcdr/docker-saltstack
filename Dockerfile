FROM cgr.dev/chainguard/wolfi-base AS builder
ARG PYTHON_VERSION=3.10
ARG SALT_VERSION=3007.8

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_PROJECT_ENVIRONMENT=/venv

USER root
WORKDIR /venv

RUN apk add --no-cache uv libcrypto3 libgit2-dev libgit2 python-${PYTHON_VERSION}-dev gcc build-base glibc-dev ld-linux swig
RUN uv venv /venv
RUN uv pip install --no-cache-dir salt==${SALT_VERSION} pygit2 croniter tornado backports.ssl_match_hostname \
    cryptography distro pyyaml looseversion packaging msgpack jinja2 pyzmq==25.1.2 zmq M2Crypto

FROM cgr.dev/chainguard/wolfi-base AS runner
ARG PYTHON_VERSION=3.10

LABEL org.opencontainers.image.title="Saltstack container"
LABEL org.opencontainers.image.description="Saltstack with minimal dependencies"
LABEL org.opencontainers.image.authors="githubcdr"
LABEL org.opencontainers.image.source="http://github.com/githubcdr/docker-saltstack"
LABEL org.opencontainers.image.licenses="Apache2"
LABEL org.opencontainers.image.vendor="githubcdr"

USER root
RUN apk add --no-cache bash python-${PYTHON_VERSION} libcrypto3 libgit2 openssh-client py${PYTHON_VERSION}-cython-bin
USER nonroot
COPY --from=builder --chown=nonroot:nonroot /venv /venv
ENV PATH=/venv/bin:$PATH

WORKDIR /venv
ENTRYPOINT ["salt-master"]
