FROM ubuntu:16.04
MAINTAINER JS Minet

ENV DEBIAN_FRONTEND=noninteractive
ENV NOMACHINE_PACKAGE_NAME nomachine_5.2.21_1_amd64.deb
ENV NOMACHINE_MD5 218372fe3591a8d91432aa1c8d6f118a
ENV BUILD_PACKAGES="curl cups mate-desktop-environment-core pulseaudio ssh vim xterm"

RUN apt-get update && apt-get install -y $BUILD_PACKAGES \
&& rm -rf /var/lib/apt/lists/*

ADD nxserver.sh /

RUN curl -fSL "http://download.nomachine.com/download/5.2/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& dpkg -i nomachine.deb \
&& groupadd -r nomachine -g 433 \
&& useradd -u 431 -r -g nomachine -d /home/nomachine -s /bin/bash -c "NoMachine" nomachine \
&& mkdir /home/nomachine \
&& chown -R nomachine:nomachine /home/nomachine \
&& echo 'nomachine:nomachine' | chpasswd \
&& rm -f nomachine.deb \
&& service ssh start \
&& chmod +x /nxserver.sh

RUN echo 'root:host12345' | chpasswd
RUN mkdir -p /root/bin
WORKDIR /root/bin

RUN wget https://download.jetbrains.com/ruby/RubyMine-2017.1.3.tar.gz \
&& tar -xvzf RubyMine-2017.1.3.tar.gz \
&& rm RubyMine-2017.1.3.tar.gz


ENTRYPOINT ["/nxserver.sh"]

EXPOSE 22 4000
