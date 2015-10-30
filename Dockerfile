FROM debian:jessie
MAINTAINER Yung Hwa Kwon <yung.kwon@damncarousel.com>

# install dependencies
RUN apt-get update && apt-get install -y \
	curl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# uid 1001 is my local user's uid
RUN adduser --disabled-password --uid 1001 --gecos '' btsy

# install btsync
RUN mkdir -p /sync /opt/btsync/.sync && cd /opt \
	&& curl -O https://download-cdn.getsync.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz \
	&& tar xzvf BitTorrent-Sync_x64.tar.gz -C ./btsync \
	&& rm BitTorrent-Sync_x64.tar.gz \
	&& chown -R btsy:btsy /sync /opt/btsync


# simple loop file to allow btsync to run as daemon and keep docker alive. This
# removes the need to pipe the --nodeamon output to null (which continues to
# grown the volume size otherwise)
COPY ./loop /usr/local/bin/

COPY ./docker-entrypoint  /
ENTRYPOINT [ "/docker-entrypoint" ]
CMD [ "/bin/sh", "-c", "./btsync --webui.listen 0.0.0.0:8888 ; loop" ]

USER btsy
WORKDIR /opt/btsync

# /sync is the volumne that contains all my syncable directories. It does not
# sync this directory directly.
VOLUME /sync

# /opt/btsync/.sync is btsync data directory that holds all the conifgurations
# for syncs.
VOLUME /opt/btsync/.sync

EXPOSE 8888 61134
