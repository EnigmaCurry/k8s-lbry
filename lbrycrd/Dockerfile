FROM ubuntu:18.04

LABEL MAINTAINER="ryan@enigmacurry.com"

ARG lbry_version="v0.12.4.0"

RUN apt-get update && \
  apt-get -y install unzip wget curl && \
  apt-get autoclean -y && \
  rm -rf /var/lib/apt/lists/* && \
  addgroup --gid 1000 lbrycrd && \
  adduser lbrycrd --uid 1000 --gid 1000 --gecos GECOS --shell /bin/bash --disabled-password --home /data && \
  wget -O /usr/bin/lbrycrd-linux.zip https://github.com/lbryio/lbrycrd/releases/download/$lbry_version/lbrycrd-linux.zip && \
  cd /usr/bin/ && \
  unzip lbrycrd-linux.zip && \
  rm lbrycrd-linux.zip && \
  chmod +x lbrycrdd lbrycrd-cli lbrycrd-tx && \
  mkdir -p /etc/lbry && \
  mkdir -p /data && \
  chown -R lbrycrd:lbrycrd /data && \
  chmod -R 755 /data

VOLUME ["/data"]

## Exposing daemon port and RPC port
EXPOSE 9245 9246

USER lbrycrd
WORKDIR /data

CMD /usr/bin/lbrycrdd -server -conf=/etc/lbry/lbrycrd.conf -printtoconsole
