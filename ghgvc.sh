#!/bin/bash

# GHGVC install script for rails application
# Written by Carl Crott <carlcrott@gmail.com>
# updated by David LeBauer <dlebauer@gmail.com>

GIT_GHGVC='https://github.com/ebimodeling/ghgvc.git'
GIT_GHGVCR='https://github.com/ebimodeling/ghgvcR.git'
INSTALL_DIR='/opt/ghgvc'
RUBY_VERSION='1.9.3-p125'
RUBY_USE="$RUBY_VERSION@ghgvc"
NGINX_CONFIG='/opt/nginx/conf/nginx.conf'
NGINX_INIT_URL='http://library.linode.com/assets/660-init-deb.sh'
NETCDF_URL='http://www.gfd-dennou.org/arch/ruby/products/ruby-netcdf/release/ruby-netcdf-0.6.6.tar.gz'
USER=$(whoami)

function install_apt_packages {
#apt
sudo apt-get update
sudo apt-get -y install python-software-properties apt-transport-https ca-certificates

#node.js
sudo apt-add-repository -y ppa:chris-lea/node.js

#R
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo bash -c "echo 'deb http://cran.rstudio.com/bin/linux/ubuntu $(lsb_release -s -c)/' > /etc/apt/sources.list.d/R.list"

#upgrade
sudo apt-get update
sudo apt-get -y dist-upgrade

APT_PACKAGES='
apache2
autoconf
automake
bc
bison
build-essential
curl
emacs
gfortran
git
git-core
jags
libapache2-mod-php5
libc6-dev
libcurl4-openssl-dev
libdbd-mysql
libhdf5-openmpi-1.8.4
libhdf5-openmpi-dev
liblapack-dev
libmysqlclient-dev
libnetcdf-dev
libproj-dev
libsqlite3-0
libsqlite3-dev
libssl-dev
libtool
libudunits2-dev
libxml2-dev
libxslt-dev
libyaml-dev
locate
mysql-client
mysql-server
ncurses-dev
netcdf-bin
nodejs
openmpi-bin
openssl
php5
php5-mysql
r-base-core
r-cran-xml
sqlite3
subversion
texinfo
texlive-fonts-recommended
texlive-latex-base
texlive-latex-extra
udunits-bin
zlib1g
zlib1g-dev
'
sudo apt-get -y install $APT_PACKAGES
}

function prepare_install_dir {
  sudo rm -rf $INSTALL_DIR
  sudo mkdir -p $INSTALL_DIR
  sudo chown -R $USER $INSTALL_DIR
}

function git_clone {
  cd $INSTALL_DIR
  git clone $GIT_GHGVC
  git clone $GIT_GHGVCR
}

function install_rvm {
  cd ~
  curl -L https://get.rvm.io | bash -s stable --ruby=$RUBY_VERSION --autolibs=enable --auto-dotfiles
  source ~/.rvm/scripts/rvm
  rvm reload
  sudo groupadd rvm
  rvm group add rvm $USER
  rvm reload
  echo "export rvm_trust_rvmrcs_flag=1" > ~/.rvmrc  #auto-trust .rvmrc flags
  echo "export rvmsudo_secure_path=1" >> ~/.rvmrc
  source ~/.rvmrc
  source ~/.bashrc
  source ~/.bash_profile
  rvm --default use ruby-$RUBY_VERSION
  cd $INSTALL_DIR/ghgvc
}

function install_netcdf {
  cd $INSTALL_DIR/ghgvc
  NARRAY_DIR="$(ls $GEM_HOME/gems | grep 'narray-')"
  NARRAY_PATH="$GEM_HOME/gems/$NARRAY_DIR"
  cd $MY_RUBY_HOME/bin
  wget $NETCDF_URL -O netcdf.tgz
  tar zxf netcdf.tgz && cd ruby-netcdf-0.6.6/
  ruby -rubygems extconf.rb --with-narray-include=$NARRAY_PATH
  # edit make makefile per https://bbs.archlinux.org/viewtopic.php?id=163623
  sed -i 's|rb/$|rb|' Makefile
  make
  make install
  cd ../ && sudo rm -rf ruby-netcdf*
}

function install_bundle {
  cd $INSTALL_DIR/ghgvc
  git checkout name_indexing
  bundle install --without development
  # build out and workaround for specifying production
  RAILS_ENV=production bundle exec rake db:create db:schema:load
}

function configure_db {
  cat <<EOF > $INSTALL_DIR/ghgvc/config/database.yml
development:
  adapter: mysql2
  database: ghgvc_dev
  pool: 5
  timeout: 5000

test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000

production:
  adapter: sqlite3
  database: db/prod.sqlite3
  pool: 5
  timeout: 5000
EOF
}

function install_nginx {
  sudo service apache2 stop >/dev/null 2>&1
  sudo service nginx stop >/dev/null 2>&1
  sudo update-rc.d -f apache2 remove >/dev/null 2>&1

  cd $INSTALL_DIR/ghgvc
  gem install passenger
  PASSENGER_VERSION="$(ls $GEM_HOME/gems | grep 'passenger-' | cut --complement -c 1-10)"
  rvmsudo passenger-install-nginx-module
}

function configure_nginx {
  cat <<EOF > nginx.conf
worker_processes  1;
events {
  worker_connections  1024;
}
http {
  passenger_root     $HOME/.rvm/gems/ruby-$RUBY_USE/gems/passenger-$PASSENGER_VERSION;
  passenger_ruby     $HOME/.rvm/wrappers/ruby-$RUBY_USE/ruby;
  include            mime.types;
  default_type       application/octet-stream;
  sendfile           on;
  keepalive_timeout  65;

  server {
    listen       80;
    server_name  localhost;
    location / {
      root $INSTALL_DIR/ghgvc/public;   # <--- be sure to point to 'public'!
      passenger_enabled on;
      index  index.html index.htm;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   html;
    }
  }

}
EOF

  sudo mv -f nginx.conf $NGINX_CONFIG
  wget -O init-deb.sh $NGINX_INIT_URL
  sudo mv -f init-deb.sh /etc/init.d/nginx
  sudo chmod +x /etc/init.d/nginx
  sudo /usr/sbin/update-rc.d -f nginx defaults
  sudo service nginx start
  echo "Nginx configured"
}

function install_r_deps {
  cd $INSTALL_DIR/ghgvc
  # devtools: http://stackoverflow.com/questions/16467725/r-devtools-github-install-fails
  echo "Configure R and devtools for ghgvcR code"
  # install devtools
  echo 'install.packages("devtools", repos="http://cran.rstudio.com/")' | sudo R --vanilla
  #install R dependencies
  chmod +x install.dependencies.R
  ./install.dependencies.R
}

install_apt_packages
prepare_install_dir
git_clone
install_rvm
install_netcdf
configure_db
install_nginx
configure_nginx
install_bundle
install_r_deps
