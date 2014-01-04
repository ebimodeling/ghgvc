#!/bin/bash
# GHGVC install script for rails application
# Written by Carl Crott <carlcrott@gmail.com>


sudo apt-get -y install git-core curl locate
git clone http://github.com/delinquentme/ghgvc.git


curl -L https://get.rvm.io | bash -s stable --ruby
## RVM reqs
sudo apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion


RVM_DIR=$(which rvm)
if [ $RVM_DIR ]; then 
  echo "RVM confirmed"
  rvm install ruby-1.9.3-p125
  rvm --default use ruby-1.9.3-p125
  echo "export rvm_trust_rvmrcs_flag=1" > ~/.rvmrc  #auto-trust .rvmrc flags
  cd ghgvc/
  git checkout name_indexing
  bundle install --without development

  # build out net-cdf parsing
  sudo apt-get -y install netcdf-bin libnetcdf-dev
  
  cd /home/ubuntu/.rvm/rubies/ruby-1.9.3-p125/bin/
  
  rvm --default use ruby-1.9.3-p125
  wget http://www.gfd-dennou.org/arch/ruby/products/ruby-netcdf/release/ruby-netcdf-0.6.6.tar.gz
  tar -zxvf ruby-netcdf-0.6.6.tar.gz && cd ruby-netcdf-0.6.6/
  ruby -rubygems extconf.rb --with-narray-include=/home/ubuntu/.rvm/gems/ruby-1.9.3-p125@ghgvc/gems/narray-0.6.0.8/
  
  # edit make makefile per:
  #https://bbs.archlinux.org/viewtopic.php?id=163623
  
  sudo make
  sudo make install

  cd ../ && sudo rm -rf ruby-netcdf*

  # build out and workaround for specifying production
  RAILS_ENV=production bundle exec rake db:create db:schema:load

else
  echo " SSH back in to re-source RVM "
  exit
fi


cat << 'EOF' > /config/setup_load_paths.rb
  if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
    begin
      gems_path = ENV['MY_RUBY_HOME'].split(/@/)[0].sub(/rubies/,'gems')
      ENV['GEM_PATH'] = "#{gems_path}:#{gems_path}@global"
      require 'rvm'
      RVM.use_from_path! File.dirname(File.dirname(__FILE__))
    rescue LoadError
      raise "RVM gem is currently unavailable."
    end
  end

  # If you're not using Bundler at all, remove lines bellow
  ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
  require 'bundler/setup'
EOF



## MySQL reqs
sudo apt-get -y install libxslt-dev libxml2-dev libsqlite3-dev libmysqlclient-dev

cd ~/ghgvc/

###### Server Configs ###
sudo useradd deploy
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev curl git-core python-software-properties
gem install passenger
#passenger-install-nginx-module
rvmsudo -E /home/ubuntu/.rvm/wrappers/ruby-1.9.3-p125@ghgvc/ruby /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@ghgvc/gems/passenger-4.0.19/bin/passenger-install-nginx-module

sudo chown -R ubuntu /home/ubuntu/ghgvc/*
echo 1.9.3-p125@ghgvc >> .ruby-version


wget -O init-deb.sh http://library.linode.com/assets/660-init-deb.sh
sudo mv init-deb.sh /etc/init.d/nginx
sudo chmod +x /etc/init.d/nginx
sudo /usr/sbin/update-rc.d -f nginx defaults







cat <<'EOF' > ~/ghgvc/config/database.yml
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

# irb 
# require 'numru/netcdf'



sudo service nginx stop

sudo rm /opt/nginx/conf/nginx.conf

sudo cat <<'EOF' > nginx.conf
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    passenger_root /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@ghgvc/gems/passenger-4.0.19;
    passenger_ruby /home/ubuntu/.rvm/wrappers/ruby-1.9.3-p125@ghgvc/ruby;
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;
	      location / {
	          root /home/ubuntu/ghgvc/public;   # <--- be sure to point to 'public'!
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

sudo cp nginx.conf /opt/nginx/conf/nginx.conf
sudo service nginx start


sudo apt-add-repository -y ppa:chris-lea/node.js
sudo apt-get -y install nodejs

sudo service nginx restart

echo "Nginx configured"


echo "Installing ghgvcR libs"

cd ~/
git clone http://github.com/delinquentme/ghgvcR
git clone http://github.com/PecanProject/pecan



echo "deb http://lib.stat.cmu.edu/R/CRAN/bin/linux/ubuntu precise/" >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y install libcurl4-gnutls-dev r-cran-xml

# devtools:
#http://stackoverflow.com/questions/16467725/r-devtools-github-install-fails


echo "configure R and devtools for ghgvcR code"
#git clone git://github.com/hadley/devtools.git && R CMD build devtools
#R CMD install devtools_1.3.99.tar.gz /home/ubuntu/R/x86_64-pc-linux-gnu-library/2.14/
#sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu `lsb_release -s -c`/" > /etc/apt/sources.list.d/R.list
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
#sudo apt-get -y update && sudo apt-get -y upgrade

#sudo apt-get -y install build-essential git gfortran openmpi-bin libhdf5-openmpi-dev r-base-core jags liblapack-dev libnetcdf-dev netcdf-bin bc libcurl4-openssl-dev curl udunits-bin libudunits2-dev libmysqlclient-dev 

#sudo apt-get -y install libgdal1-dev libproj-dev

#echo 'install.packages("devtools", repos="http://cran.rstudio.com/")' | R --vanilla



#echo 'install.packages("devtools", repos="http://cran.rstudio.com/")' | R --vanilla
sudo apt-get -y install gksu
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo echo "deb http://cran.cnr.berkeley.edu/bin/linux/ubuntu precise/" >> /etc/apt/sources.list


sudo apt-get update
sudo apt-get -y install r-base



########################
sudo cat <<'EOF' > ./build_ghgvcR.r
install.packages("devtools") # this causes issues on ubuntu 12.04
install.packages("RCurl"); install.packages("rjson"); install.packages("httr")

library(devtools)
install("~/ghgvcR/")
install("/home/thrive/rails_projects/PEcAn/utils")
EOF
##############################

sudo chmod 0755 ./build_ghgvcR.r && ./build_ghgvcR.r


cd ~/ghgvcR/
sudo chmod 0755 /src/ghgvc_script.R
./src/ghgvc_script.R



#sudo apt-get -y install r-base-core=2.15.3* r-recommended=2.15.3* r-doc-html=2.15.3* r-base=2.15.3*



#$IP_ADDY=$(curl http://canhazip.com/)
#http://ec2-184-73-47-14.compute-1.amazonaws.com/
echo "GHGVC Server build complete."



#ssh -v -i ~/.ec2/ec2.pem ubuntu@ec2-184-73-47-14.compute-1.amazonaws.com
