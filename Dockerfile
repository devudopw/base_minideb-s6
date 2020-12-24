ARG MINIDEB_RELEASE=buster

FROM mirror.gcr.io/bitnami/minideb:$MINIDEB_RELEASE AS build

ARG S6_VERSION=v2.1.0.2
ARG S6_ARCH=amd64

ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz

RUN groupadd -r user -g 1000 && \
    useradd --no-log-init -r -M -g user -u 1000 -s /usr/sbin/nologin user

RUN apt update && \
    BUILD_PACKAGES="wget ca-certificates" && \
    apt install -qy --no-install-recommends $BUILD_PACKAGES && \
    wget -qO- $S6_OVERLAY_URL | tar xzC / && \
    apt remove -qy --purge $BUILD_PACKAGES $(apt-mark showauto) && \
    rm -rf /var/lib/apt/lists/*

COPY ./ /

ENTRYPOINT ["/init"]