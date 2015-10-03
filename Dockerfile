FROM debian:jessie
MAINTAINER Yung Hwa Kwon <yung.kwon@damncarousel.com>

RUN apt-get update \
	&& apt-get -y install wget

# uid 1001 is my local user's uid
RUN adduser --disabled-password --uid 1001 --gecos '' btsy

RUN mkdir -p /sync /opt/btsync/.sync && cd /opt \
	&& wget https://download-cdn.getsync.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz \
	&& tar xzvf BitTorrent-Sync_x64.tar.gz -C ./btsync \
	&& rm BitTorrent-Sync_x64.tar.gz \
	&& chown -R btsy:btsy /sync /opt/btsync

# clean up
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER btsy
WORKDIR /opt/btsync
# dump all log output, long running btsync sessions begin to eat away at disk
# space
CMD ./btsync --nodaemon --webui.listen 0.0.0.0:8888 >/dev/null 2>&1

EXPOSE 8888 61134

# /sync is the volumne that contains all my syncable directories. It does not
# sync this directory directly.
VOLUME /sync

# /opt/btsync/.sync is btsync data directory that holds all the conifgurations
# for syncs.
VOLUME /opt/btsync/.sync

