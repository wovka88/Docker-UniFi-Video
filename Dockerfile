FROM phusion/baseimage:0.9.19
MAINTAINER wovka88 "wovka@icloud.com"

RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list && \
    apt-get update && apt-get dist-upgrade -y && apt-get install -y mongodb-org && \
    curl -L https://dl.ubnt.com/firmwares/unifi-video/3.6.2/unifi-video_3.6.2~Debian7_amd64.deb -o /tmp/unifi-video.deb && \
    mkdir -p /var/cache/unifi-video && \
    mkdir -p /var/run/unifi-video && \
    dpkg -i /tmp/unifi-video.deb || /bin/true && apt-get -yf --force-yes install && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    sed -i.bak 's/ulimit -H -c 200//g' /usr/sbin/unifi-video && \
    sed -i.bak 's/PKGUSER=unifi-video/PKGUSER=root/g' /usr/sbin/unifi-video && \
    chmod 755 /usr/sbin/unifi-video && \
    chown -R root.root /var/lib/unifi-video /usr/lib/unifi-video /var/log/unifi-video

ADD start.sh /bin
RUN /bin/chmod +x /bin/start.sh

EXPOSE 1935 6666 7080 7443 7445 7446 7447 

ENV SHELL /bin/bash

CMD []
ENTRYPOINT ["/bin/start.sh"]
