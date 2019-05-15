#!/bin/bash

sudo apt-get -y update

wget https://github.com/minishift/minishift/releases/download/v1.33.0/minishift-1.33.0-linux-amd64.tgz

tar xvf minishift-1.33.0-linux-amd64.tgz

mv /home/vaagrant/home/vagrant/minishift-1.33.0-linux-amd64/minishift /usr/local/bin/


