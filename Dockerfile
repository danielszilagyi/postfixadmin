FROM alpine:3.21.6

LABEL description="PostfixAdmin is a web based interface used to manage mailboxes"

ARG VERSION=3.3.16
ARG PHP_VERSION=84
ARG SHA256_HASH="93df38f59b3a35748ec4e3528392422f688362fdea507569ec3b9d8ebb07a3fd"

RUN set -eux; \
    apk update && apk upgrade; \
    apk add --no-cache \
        bash \
        su-exec \
        dovecot \
        tini \
        \
        php \
        php-curl \
        php-dom \
        php-fpm \
        php-iconv \
        php-imap \
        php-intl \
        php-mbstring \
        php-mysqli \
        php-pdo \
        php-pdo_mysql \
        php-pdo_pgsql \
        php-pgsql \
        php-phar \
        php-session \
        php-simplexml \
        php-sqlite3 \
        php-tokenizer \
        php-xml \
        php-xmlwriter \
    ; \
    \
    PFA_TARBALL="v${VERSION}.tar.gz"; \
    wget -q https://github.com/postfixadmin/postfixadmin/archive/${PFA_TARBALL}; \
    echo "${SHA256_HASH} *${PFA_TARBALL}" | sha256sum -c; \
    \
    mkdir /postfixadmin; \
    tar -xzf ${PFA_TARBALL} --strip-components=1 -C /postfixadmin; \
    rm -f ${PFA_TARBALL}; \
    chmod 644 /etc/ssl/dovecot/server.key

COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*
EXPOSE 8888
CMD ["tini", "--", "run.sh"]
