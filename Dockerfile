FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends lua5.3 liblua5.3-dev lua5.3-lgi build-essential libreadline-dev unzip libxwiimote-dev lua-json wget cmake git gtk-3.0 ca-certificates && rm -rf /var/lib/apt/lists/*

ENV LUAROCKS_VERSION 3.8.0
RUN wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz && tar zxpf luarocks-3.8.0.tar.gz && rm luarocks-3.8.0.tar.gz && cd luarocks-3.8.0 && ./configure --prefix=/usr/local && make && make install && cd / && rm -rf luarocks-3.8.0

RUN luarocks --lua-version=5.3 install crc32
RUN luarocks --lua-version=5.3 install lua-xwiimote

RUN git clone https://github.com/v1993/linuxmotehook /linuxmotehook
WORKDIR /linuxmotehook

COPY ./listen-global.patch /listen-global.patch
RUN patch -p1 </listen-global.patch

EXPOSE 26760/udp
CMD ["./main.lua"]