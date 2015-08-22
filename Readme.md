# docker-btsync

Btsync docker container

## Usage

Build:

    docker build --rm -t btsync .

Run:

    docker run \
      -v /home/nowk/devs:/sync -v /home/nowk/opt/btsync/.sync:/opt/btsync/.sync \
      -p 8888:8888 --name btsync -d btsync

*`/sync` volume is specific to my needs. Add or adjust as required.*

