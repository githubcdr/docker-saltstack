FROM cgr.dev/chainguard/wolfi-base AS builder
ARG TARGETARCH
ARG VERSION=3.12

USER root
RUN apk add --no-cache --update-cache python-${VERSION} cython libcrypto3 libgit2-dev libgit2 python-${VERSION}-dev gcc build-base glibc-dev ld-linux
RUN python -m venv /venv
RUN /venv/bin/pip install -U pip
RUN /venv/bin/pip install salt pygit2 croniter tornado backports.ssl-match-hostname pycrypto
RUN /venv/bin/pip uninstall -y setuptools pip

FROM cgr.dev/chainguard/wolfi-base AS runner
LABEL org.opencontainers.image.title "Saltstack container"
LABEL org.opencontainers.image.description "Saltstack with minimal dependencies"
LABEL org.opencontainers.image.authors "githubcdr"
LABEL org.opencontainers.image.source "http://github.com/githubcdr/docker-saltstack"
LABEL org.opencontainers.image.licenses "Apache2"
LABEL org.opencontainers.image.vendor "githubcdr"
ARG TARGETARCH
ARG VERSION=3.12
USER root
#RUN apk add --no-cache --update-cache bash python3 cython libcrypto3 ca-certificates libgit2 py3-cryptography py3-oscrypto && \
RUN apk add --no-cache --update-cache bash python-${VERSION} cython libcrypto3 libgit2 openssh-client && \
    ldconfig -v
USER nonroot
COPY --from=builder --chown=nonroot:nonroot /venv /venv
ENV PATH=$PATH:/venv/bin
ENTRYPOINT ["salt-master", "-l", "warning"]
