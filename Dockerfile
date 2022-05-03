FROM ubuntu:latest

ENV STRONGSWAN_VERSION=5.9.6

RUN apt update &&\
	apt install -y wget bzip2 make build-essential libgmp-dev libssl-dev iptables &&\
	apt clean -y

WORKDIR /opt

RUN wget https://download.strongswan.org/strongswan-$STRONGSWAN_VERSION.tar.bz2 > /dev/null 2>&1 \
&& tar xjvf strongswan-$STRONGSWAN_VERSION.tar.bz2 > /dev/null 2>&1 \
&& cd strongswan-$STRONGSWAN_VERSION \
&& ./configure --prefix=/usr --sysconfdir=/etc \
		--enable-gmp \
		--enable-vici \
		--enable-openssl \
		--enable-eap-identity \
		--enable-eap-md5 \
		--enable-eap-tls \
		--enable-eap-radius \
		--enable-eap-ttls \
		--enable-eap-peap \
		--enable-eap-dynamic \
&& make -j  \
&& make install \
&& cd - && rm -rf strongswan-*

EXPOSE 500/udp
EXPOSE 4500/udp

RUN mkdir -p /opt/swanconf &&\
	ln -s -f /opt/swanconf/eap-radius.conf /etc/strongswan.d/charon/eap-radius.conf &&\
	ln -s -f /opt/swanstatic/strongswan.conf /etc/strongswan.conf &&\
	ln -s -f /opt/swanconf/swanctl.conf /etc/swanctl/swanctl.conf &&\
	ln -s -f /opt/swanconf/tls.key /etc/swanctl/private/private.key &&\
	ln -s -f /opt/swanconf/tls.crt /etc/swanctl/x509/server.crt

COPY conf /opt/swanconf
COPY static /opt/swanstatic

ENTRYPOINT ./swanconf/entrypoint.sh