#!/bin/bash

# update package database
sudo apt-get -q -y update 

# download docker-compose binary
sudo curl -s -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose


