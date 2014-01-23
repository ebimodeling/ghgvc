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
NETCDF_URL='http://www.gfd-dennou.org/arch/ruby/products/ruby-netcdf/release/ruby-netcdf-0.6.6.tar.gz'
USER=$(whoami)

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

YUM_PACKAGES='
gcc
git
libxml2
libxml2-devel
make
mysql
mysql-devel
mysql-server
netcdf
netcdf-devel
pcre
pcre-devel
R-core
R-core-devel
sqlite-devel
'


function determine_distro {
  if [[ -f /etc/redhat-release ]]; then
    DISTRO=el
  elif grep Ubuntu /etc/issue >/dev/null 2>&1; then
    DISTRO=ubuntu
  else
    echo "Unsupported Linux distribution!"
    exit 1
  fi
}

function install_packages_apt {
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

  sudo apt-get -y install $APT_PACKAGES
}

function install_packages_yum {
  install_epel
  sudo yum clean all
  sudo yum -y update
  sudo yum -y install $YUM_PACKAGES
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
}

function install_netcdf {
  cd $INSTALL_DIR/ghgvc
  NARRAY_DIR="$(ls $GEM_HOME/gems | grep 'narray-')"
  NARRAY_PATH="$GEM_HOME/gems/$NARRAY_DIR"
  cd $MY_RUBY_HOME/bin
  wget $NETCDF_URL -O ruby-netcdf.tgz
  tar zxf ruby-netcdf.tgz && cd ruby-netcdf-0.6.6/
  ruby -rubygems extconf.rb --with-narray-include=$NARRAY_PATH
  # edit make makefile per https://bbs.archlinux.org/viewtopic.php?id=163623
  sed -i 's|rb/$|rb|' Makefile
  make
  make install
  cd ../ && sudo rm -rf ruby-netcdf*
}

function install_bundle {
  cd $INSTALL_DIR/ghgvc
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
  disable_apache
  sudo service nginx stop >/dev/null 2>&1
  chmod o+x $HOME #so Nginx could use Passenger

  cd $INSTALL_DIR/ghgvc
  gem install passenger
  PASSENGER_VERSION="$(ls $GEM_HOME/gems | grep 'passenger-' | cut --complement -c 1-10)"
  rvmsudo passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download --languages ruby
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

  cat <<'EOF' > nginx.init.el
#!/bin/sh
#
# nginx - this script starts and stops the nginx daemon
#
# chkconfig:   - 85 15
# description:  Nginx is an HTTP(S) server, HTTP(S) reverse \
#               proxy and IMAP/POP3 proxy server
# processname: nginx
# config:      /etc/nginx/nginx.conf
# config:      /etc/sysconfig/nginx
# pidfile:     /var/run/nginx.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

nginx="/opt/nginx/sbin/nginx"
prog=$(basename $nginx)

NGINX_CONF_FILE="/opt/nginx/conf/nginx.conf"

[ -f /etc/sysconfig/nginx ] && . /etc/sysconfig/nginx

lockfile=/var/lock/subsys/nginx

start() {
    [ -x $nginx ] || exit 5
    [ -f $NGINX_CONF_FILE ] || exit 6
    echo -n $"Starting $prog: "
    daemon $nginx -c $NGINX_CONF_FILE
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $prog -TERM
    retval=$?
    if [ $retval -eq 0 ]; then
        if [ "$CONSOLETYPE" != "serial" ]; then
           echo -en "\\033[16G"
        fi
        while rh_status_q
        do
            sleep 1
            echo -n $"."
        done
        rm -f $lockfile
    fi
    echo
    return $retval
}

restart() {
    configtest || return $?
    stop
    start
}

reload() {
    configtest || return $?
    echo -n $"Reloading $prog: "
    killproc $nginx -HUP
    sleep 1
    RETVAL=$?
    echo
}

configtest() {
  $nginx -t -c $NGINX_CONF_FILE
}

rh_status() {
    status $prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}

# Upgrade the binary with no downtime.
upgrade() {
    local pidfile="/var/run/${prog}.pid"
    local oldbin_pidfile="${pidfile}.oldbin"

    configtest || return $?
    echo -n $"Staring new master $prog: "
    killproc $nginx -USR2
    sleep 1
    retval=$?
    echo 
    if [[ -f ${oldbin_pidfile} && -f ${pidfile} ]];  then
        echo -n $"Graceful shutdown of old $prog: "
        killproc -p ${oldbin_pidfile} -TERM
        sleep 1
        retval=$?
        echo 
        return 0
    else
        echo $"Something bad happened, manual intervention required, maybe restart?"
        return 1
    fi
}

case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart|configtest)
        $1
        ;;
    force-reload|upgrade) 
        rh_status_q || exit 7
        upgrade
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    status|status_q)
        rh_$1
        ;;
    condrestart|try-restart)
        rh_status_q || exit 7
        restart
	    ;;
    *)
        echo $"Usage: $0 {start|stop|reload|configtest|status|force-reload|upgrade|restart}"
        exit 2
esac
EOF

  cat <<'EOF' > nginx.init.ubuntu
#! /bin/sh

### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon
### END INIT INFO

PATH=/opt/nginx/sbin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/opt/nginx/sbin/nginx
NAME=nginx
DESC=nginx

test -x $DAEMON || exit 0

# Include nginx defaults if available
if [ -f /etc/default/nginx ] ; then
        . /etc/default/nginx
fi

set -e

case "$1" in
  start)
        echo -n "Starting $DESC: "
        start-stop-daemon --start --quiet --pidfile /opt/nginx/logs/$NAME.pid \
                --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --quiet --pidfile /opt/nginx/logs/$NAME.pid \
                --exec $DAEMON
        echo "$NAME."
        ;;
  restart|force-reload)
        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --quiet --pidfile \
                /opt/nginx/logs/$NAME.pid --exec $DAEMON
        sleep 1
        start-stop-daemon --start --quiet --pidfile \
                /opt/nginx/logs/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  reload)
          echo -n "Reloading $DESC configuration: "
          start-stop-daemon --stop --signal HUP --quiet --pidfile     /opt/nginx/logs/$NAME.pid \
              --exec $DAEMON
          echo "$NAME."
          ;;
      *)
            N=/etc/init.d/$NAME
            echo "Usage: $N {start|stop|restart|reload|force-reload}" >&2
            exit 1
            ;;
    esac

    exit 0
EOF

  sudo mv -f nginx.conf $NGINX_CONFIG
  NGINX_INIT_SCRIPT="nginx.init.$DISTRO"
  sudo mv -f $NGINX_INIT_SCRIPT /etc/init.d/nginx
  sudo chmod +x /etc/init.d/nginx
  enable_nginx
  rm -f nginx.init*
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
  sudo ./install.dependencies.R
}

function install_epel {
  EL_RELEASE="$(cat /etc/redhat-release | tr -cd '[[:digit:]]' | cut -c 1)"
  ARCH="$(uname -m)"
  EPEL_URL="http://download.fedoraproject.org/pub/epel/$EL_RELEASE/$ARCH/epel-release-6-8.noarch.rpm"
  sudo rpm -Uvh $EPEL_URL
  case "$EL_RELEASE" in
    5)
      EPEL_GPG_FILE='/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL'
    ;;
    6)
      EPEL_GPG_FILE='/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6'
    ;;
    *)
      echo "Error: can't determine Enterprise Linux release."
      exit 1
    ;;
  esac
  sudo rpm --import $EPEL_GPG_FILE
}


function install_packages {
  case $DISTRO in
    el)
      install_packages_yum
    ;;
    ubuntu)
      install_packages_apt
    ;;
    *)
      echo "Unsupported Linux distribution!"
      exit 1
    ;;
  esac
}

function disable_apache {
  case $DISTRO in
    el)
      sudo service httpd stop >/dev/null 2>&1
      sudo chkconfig httpd off >/dev/null 2>&1
    ;;
    ubuntu)
      sudo service apache2 stop >/dev/null 2>&1
      sudo update-rc.d -f apache2 remove >/dev/null 2>&1
    ;;
    *)
      echo "Unsupported Linux distribution!"
      exit 1
    ;;
  esac
}

function enable_nginx {
  case $DISTRO in
    el)
      sudo chkconfig --add nginx
      sudo chkconfig nginx on
    ;;
    ubuntu)
      sudo /usr/sbin/update-rc.d -f nginx defaults
    ;;
    *)
      echo "Unsupported Linux distribution!"
      exit 1
    ;;
  esac
}


determine_distro
install_packages
prepare_install_dir
git_clone
install_rvm
configure_db
install_netcdf
install_bundle
install_nginx
configure_nginx
install_r_deps
