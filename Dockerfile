FROM 0x416e746f6e0a/alpine-base:3.10

# set maintainer label
LABEL MAINTAINER="Anton Chen <contact@antonchen.com>"

RUN \
 if [ `arch` = "x86_64" ]; then \
   apk add --no-cache --virtual phantomjs-utils curl && \
   cd /tmp && \
   curl -Ls https://github.com/dustinblackman/phantomized/releases/download/2.1.1/dockerized-phantomjs.tar.gz | tar xz && \
   cp -R lib lib64 / && \
   cp -R usr/lib/x86_64-linux-gnu /usr/lib && \
   cp -R usr/share/fonts /usr/share && \
   cp -R etc/fonts /etc && \
   rm -rf /tmp/* && \
   apk del --no-cache phantomjs-utils; \
 fi

ARG ARCH=amd64
ARG VERSION=6.3.5

ADD https://dl.grafana.com/oss/release/grafana-${VERSION}.linux-${ARCH}.tar.gz /tmp/grafana.tar.gz
RUN \
 mkdir /tmp/grafana && tar xfz /tmp/grafana.tar.gz --strip-components=1 -C /tmp/grafana && \
 cd /tmp/grafana && rm -f LICENSE NOTICE.md README.md VERSION && \
 cd /tmp/grafana/bin && rm -f *.md5 && \
 cd /tmp && mv /tmp/grafana /opt/grafana && \
 echo "**** cleanup ****" && \
  rm -rf \
      /tmp/*

# copy local files
COPY root/ /

EXPOSE 3000
VOLUME ["/grafana"]
