###Clean GHGVC Install on CentOS
```bash
sudo yum install wget
wget https://raw.githubusercontent.com/ebimodeling/ghgvc/development/ghgvc.sh
sh ./ghgvc.sh
```

You may have to run the script a few different times, addressing errors, and commenting out the steps you've already run that are at the bottom of the script.

You may also get an error if bundler doesn't install in the correct rvm environment, in which case you can do it manually:

```bash
cd /opt/ghgvc/ghgvc
gem install bundler
bundle install --without development
RAILS_ENV=production bundle exec rake db:create db:schema:load
#Also install passenger to prevent same issue with nginx
gem install passenger
PASSENGER_VERSION="$(ls $GEM_HOME/gems | grep 'passenger-' | cut --complement -c 1-10)"
rvmsudo passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download --languages ruby
```

You will also have to edit `/opt/nginx/conf/nginx.conf`, replacing passenger_root with this line:

```bash
http {
    ...
    passenger_root      /home/centos/.rvm/gems/ruby-1.9.3-p125@ghgvc/gems/passenger-5.0.26;
    ...
}
```

Then copy the new saatchi.nc file to the server:

```bash
cd /opt/ghgvc/ghgvc/netcdf
wget https://s3-us-west-2.amazonaws.com/ghgvc/saatchi.nc
```

Finally, you should be able to restart the nginx:
```bash
sudo systemctl restart nginx
#Though that script seems not to work well, so you may have to manually
#kill the nginx process and then restart it
ps -A | grep nginx
sudo kill <nginx PID>
sudo systemctl start nginx
```



