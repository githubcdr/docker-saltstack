FROM cgr.dev/chainguard/wolfi-base AS builder
ARG TARGETARCH
ARG PYTHON_VERSION=3.11
ARG SALT_VERSION=3006.5

USER root
RUN apk add --no-cache --update-cache python-${PYTHON_VERSION} cython libcrypto3 libgit2-dev libgit2 python-${PYTHON_VERSION}-dev gcc build-base glibc-dev ld-linux
RUN python -m venv /venv
RUN /venv/bin/pip install -U pip
RUN /venv/bin/pip install salt==${SALT_VERSION} pygit2 croniter tornado backports.ssl-match-hostname pycrypto
RUN /venv/bin/pip uninstall -y setuptools pip

FROM cgr.dev/chainguard/wolfi-base AS runner
ARG TARGETARCH
ARG PYTHON_VERSION=3.11
USER root
RUN apk add --no-cache --update-cache bash python-${PYTHON_VERSION} cython libcrypto3 libgit2 openssh-client && \
    ldconfig -v
USER nonroot
COPY --from=builder --chown=nonroot:nonroot /venv /venv
ENV PATH=$PATH:/venv/bin
ENTRYPOINT ["salt-master", "-l", "warning"]
