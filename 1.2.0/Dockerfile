FROM debian:jessie
MAINTAINER sparklecoin <dev@sparklecoin.com>

ENV SPRK_VERSION=1.2.0
ENV SPRK_SHA256 f52d45772644df20b0517b076ef9bb62302515d71fac3dc306319740c5e2f407
ENV GOSU_VERSION=1.9

# build
## install main dependencies
## install gosu
## unpack sparklecoind
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y curl ca-certificates build-essential libssl-dev libdb++-dev \
    libboost-program-options-dev libboost-filesystem-dev libboost-system-dev libboost-thread-dev \
    libboost-program-options1.55.0 libboost-filesystem1.55.0 libboost-system1.55.0 libboost-thread1.55.0 \
    && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
    && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && curl -SLO4 https://github.com/sparklecoin/sparklecoin/archive/v${SPRK_VERSION}.tar.gz \
    && tar xf v${SPRK_VERSION}.tar.gz \
    && echo "$SPRK_SHA256 v${SPRK_VERSION}.tar.gz" | sha256sum -c - 

## make sparklecoind
RUN cd sparklecoin-${SPRK_VERSION} \
    && make -f makefile.unix USE_UPNP= -C src \
    && install -Dm755 "src/sparklecoind" "/usr/local/bin/"

## cleanup
RUN rm v${SPRK_VERSION}.tar.gz && rm -r sparklecoin-${SPRK_VERSION} \
    && apt-get remove -y --purge curl ca-certificates build-essential libssl-dev libdb++-dev \
    libboost-program-options-dev libboost-filesystem-dev libboost-system-dev libboost-thread-dev \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd -r coin

## container stuff
ENV SPRK_DATA=/home/coin/.sparklecoin \
    PATH=/usr/local/bin/:$PATH
VOLUME ["/home/coin/.sparklecoin"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 6020 6021 16020 16021
CMD ["sparklecoind"]
