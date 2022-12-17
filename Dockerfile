ARG MINIDEB_RELEASE=buster

FROM r.sync.pw/dockerhub/bitnami/minideb:$MINIDEB_RELEASE AS build

ARG S6_VERSION=v2.2.0.3
ARG S6_ARCH=amd64

ENV S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz

RUN apt update && \
    BUILD_PACKAGES="wget ca-certificates" && \
    apt install -qy --no-install-recommends $BUILD_PACKAGES && \
    wget -qO- $S6_OVERLAY_URL | tar xzC / && \
    apt remove -qy --purge $BUILD_PACKAGES $(apt-mark showauto) && \
    rm -rf /var/lib/apt/lists/*

ARG GID=1000
ARG UID=1000

RUN groupadd --system --gid ${GID} user && \
    useradd --no-log-init --system --create-home --gid ${GID} --uid ${UID} --shell /bin/bash user

USER user

ENTRYPOINT ["/init"]
