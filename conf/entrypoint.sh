#!/usr/bin/env bash

iptables -t nat -A POSTROUTING -s 10.6.0.0/24 -o eth0 -m policy --pol ipsec --dir out -j ACCEPT  # exempt IPsec traffic from masquerading
iptables -t nat -A POSTROUTING -s 10.6.0.0/24 -o eth0 -j MASQUERADE

ipsec start --nofork "$@"