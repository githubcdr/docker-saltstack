FROM cgr.dev/chainguard/wolfi-base AS builder
ARG TARGETARCH
ARG PYTHON_VERSION=3.12
ARG SALT_VERSION=3006.7

USER root
RUN apk add --no-cache python-${PYTHON_VERSION} cython libcrypto3 libgit2-dev libgit2 python-${PYTHON_VERSION}-dev gcc build-base glibc-dev ld-linux
RUN python -m venv /venv
RUN /venv/bin/pip install -U pip
RUN /venv/bin/pip install salt==${SALT_VERSION} pygit2 croniter tornado backports.ssl-match-hostname pycrypto
RUN /venv/bin/pip uninstall -y setuptools pip

FROM cgr.dev/chainguard/wolfi-base AS runner
ARG TARGETARCH
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
COPY --from=builder --chown=nonroot:nonroot /venv /venv
ENV PATH=$PATH:/venv/bin
ENTRYPOINT ["salt-master", "-l", "warning"]
