This is a Ikev2 server with radius authentication (Jumpcloud by default)

# Build

    docker build -t ikev  .

# RUN

    docker run --rm -d --name=ikev --cap-add=NET_ADMIN -p 500:500/udp -p 4500:4500/udp j0rsa/radius-ikev2

# Recommended Prod RUN

adjust 4 files in conf directory and add it as a volume:

    docker run --rm -d --name=ikev --cap-add=NET_ADMIN -p 500:500/udp -p 4500:4500/udp -v $(pwd)/conf:/opt/swanconf j0rsa/radius-ikev2

swanctl config reference:
- https://wiki.gentoo.org/wiki/IPsec_IKEv2_MSCHAPv2_VPN_server
