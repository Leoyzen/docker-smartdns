FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="leoyzen.vip version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Leoyzen"

ENV TZ=Asia/Shanghai SMARTDNS_VERSION=latest

RUN \
	echo "**** install packages ****" \
	&& cd /tmp \
    && apk add --no-cache openssl jq libc6-compat curl \
    && archive=$(curl -fSL https://api.github.com/repos/pymumu/smartdns/releases/${SMARTDNS_VERSION}|jq -r '.assets[]|select(.name|endswith("x86_64-all.tar.gz"))|.browser_download_url') \
	&& curl -fSL ${archive} -o smartdns.tar.gz \
    && tar zxf smartdns.tar.gz \
    && cd smartdns \
    && mkdir /default/ \
    && mv etc/smartdns/smartdns.conf /default/ \
    && mv src/smartdns /usr/bin/ \
    && apk del jq \
	&& rm -rf /tmp

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 53:53/udp
VOLUME /config
