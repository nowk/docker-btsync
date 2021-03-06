FROM debian:jessie
MAINTAINER Yung Hwa Kwon <yung.kwon@damncarousel.com>

# install dependencies
RUN apt-get update && apt-get install -y \
	curl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# uid 1000 is my local user's uid
RUN adduser --disabled-password --uid 1000 --gecos '' btsy

# install btsync
RUN mkdir -p /sync /opt/btsync/.sync && cd /opt \
	&& curl -O https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz \
	&& tar xzvf resilio-sync_x64.tar.gz -C ./btsync \
	&& rm resilio-sync_x64.tar.gz \
	&& chown -R btsy:btsy /sync /opt/btsync

ENTRYPOINT [ "/opt/btsync/rslsync" ]

WORKDIR /opt/btsync
# /sync is the volumne that contains all my syncable directories. It does not
# sync this directory directly.
VOLUME /sync
# /opt/btsync/.sync is btsync data directory that holds all the conifgurations
# for syncs.
VOLUME /opt/btsync/.sync

EXPOSE 8888 61134
