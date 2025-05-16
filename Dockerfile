FROM cgr.dev/chainguard/wolfi-base AS builder
ARG PYTHON_VERSION=3.11
ARG SALT_VERSION=3007.2
ENV PYTHONDONTWRITEBYTECODE=1

USER root
RUN apk add --no-cache python-${PYTHON_VERSION} libcrypto3 libgit2-dev libgit2 python-${PYTHON_VERSION}-dev gcc build-base glibc-dev ld-linux
RUN python -m venv /venv
RUN /venv/bin/pip install --no-cache-dir -U pip
RUN /venv/bin/pip install --no-cache-dir salt==${SALT_VERSION} pygit2==1.13.1 croniter tornado pycrypto backports.ssl_match_hostname cryptography distro pyyaml
RUN /venv/bin/pip uninstall -y setuptools pip

FROM cgr.dev/chainguard/wolfi-base AS runner
ARG PYTHON_VERSION=3.11
LABEL org.opencontainers.image.title "Saltstack container"
LABEL org.opencontainers.image.description "Saltstack with minimal dependencies"
LABEL org.opencontainers.image.authors "githubcdr"
LABEL org.opencontainers.image.source "http://github.com/githubcdr/docker-saltstack"
LABEL org.opencontainers.image.licenses "Apache2"
LABEL org.opencontainers.image.vendor "githubcdr"

USER root
RUN apk add --no-cache bash python-${PYTHON_VERSION} libcrypto3 libgit2 openssh-client && ldconfig -v
USER nonroot
COPY --from=builder --chown=nonroot:nonroot /venv /venv
ENV PATH=/venv/bin:$PATH
ENTRYPOINT ["salt-master"]
