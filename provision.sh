#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get -y update

echo -n "training.hosts.started:1|c|#shell" >/dev/udp/localhost/8125

