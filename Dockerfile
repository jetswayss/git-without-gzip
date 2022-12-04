FROM alpine:3.17

RUN apk add --no-cache libstdc++ curl openssl zlib libintl \
    && apk add --no-cache --virtual .build-deps-full binutils-gold g++ gcc gnupg libgcc make tar openssl-dev gettext-dev zlib-dev curl-dev expat-dev \
    && mkdir -p /tmp \
    && cd /tmp \
    && curl -o git.tar.gz https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.1.tar.gz \
    && tar -zxf git.tar.gz \
    && cd git-* \
    && sed -i -e 's/int use_gzip = rpc->gzip_request;/int use_gzip = 0;/g' remote-curl.c \
    && ./configure \
    && make prefix=/usr/local all -j8 \
    && make prefix=/usr/local INSTALL_STRIP=-s install \
    && cd ~ \
    && apk del .build-deps-full \
    && rm -rf /tmp/git*
