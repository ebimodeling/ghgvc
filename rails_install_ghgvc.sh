#!/bin/bash
# GHGVC install script for rails application
# Written by Carl Crott <carlcrott@gmail.com>


sudo apt-get install git-core

\curl -L https://get.rvm.io | bash -s stable --ruby

sudo adduser deploy
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev curl git-core python-software-properties

bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
