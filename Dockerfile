FROM cgr.dev/chainguard/wolfi-base AS builder
ARG PYTHON_VERSION=3.11
ARG SALT_VERSION=3007.0
ENV VIRTUAL_ENV=/venv
USER root

RUN apk add --no-cache python-${PYTHON_VERSION} cython libcrypto3 libgit2-dev libgit2 python-${PYTHON_VERSION}-dev gcc build-base glibc-dev ld-linux uv
RUN uv venv ${VIRTUAL_ENV}
RUN uv pip install salt==${SALT_VERSION} pygit2 croniter tornado pycrypto

FROM cgr.dev/chainguard/wolfi-base AS runner
ARG PYTHON_VERSION=3.11
LABEL org.opencontainers.image.title "Saltstack container"
LABEL org.opencontainers.image.description "Saltstack with minimal dependencies"
LABEL org.opencontainers.image.authors "githubcdr"
LABEL org.opencontainers.image.source "http://github.com/githubcdr/docker-saltstack"
LABEL org.opencontainers.image.licenses "Apache2"
LABEL org.opencontainers.image.vendor "githubcdr"
USER root
RUN apk add --no-cache bash python-${PYTHON_VERSION} cython libcrypto3 libgit2 openssh-client && \
    ldconfig -v
USER nonroot
COPY --from=builder --chown=nonroot:nonroot ${VIRTUAL_ENV} ${VIRTUAL_ENV}
ENV PATH=$PATH:${VIRTUAL_ENV}/bin
ENTRYPOINT ["salt-master", "-l", "warning"]
