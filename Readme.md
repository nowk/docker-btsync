# docker-btsync

Btsync docker container

## Usage

Build:

    docker build --rm -t btsync .

Run:

    docker run \
      -v /home/nowk/devs:/sync \
      -v /home/nowk/opt/btsync/.sync:/opt/btsync/.sync \
      -p 8888:8888 \
      -d -it --name btsync btsync --webui.listen 0.0.0.0:8888 --nodaemon

---

Systemd:

    systemctl enable /path/to/btsync.service
    systemctl start btsync.service

