FROM debian:jessie
MAINTAINER Yung Hwa Kwon <yung.kwon@damncarousel.com>

RUN apt-get update
RUN apt-get -y install wget

# uid 1001 is my local user's uid
RUN adduser --disabled-password --uid 1001 --gecos '' btsy

RUN mkdir -p /sync /opt/btsync/.sync && cd /opt \
	&& wget https://download-cdn.getsync.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz \
	&& tar xzvf BitTorrent-Sync_x64.tar.gz -C ./btsync \
	&& rm BitTorrent-Sync_x64.tar.gz \
	&& chown -R btsy:btsy /sync /opt/btsync

USER btsy
WORKDIR /opt/btsync
ENTRYPOINT [ "./btsync" ]
CMD [ "--nodaemon", "--webui.listen", "0.0.0.0:8888" ]

EXPOSE 8888 61134
VOLUME /sync
VOLUME /opt/btsync/.sync

