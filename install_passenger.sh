# the final piece of the installation
# and the most painful by hand,.. so enjoy the automation of linux!!

yum install -y httpd httpd-devel mod_ssl ruby-devel rubygems gcc make
gem install rack passenger
passenger-install-apache2-module

# directories and files required
mkdir -p /usr/share/puppet/rack/puppetmasterd
mkdir /usr/share/puppet/rack/puppetmasterd/public /usr/share/puppet/rack/puppetmasterd/tmp
cp /usr/share/puppet/ext/rack/files/config.ru /usr/share/puppet/rack/puppetmasterd/
chown puppet /usr/share/puppet/rack/puppetmasterd/config.ru

# the apache configuration
cat << EOF > /etc/httpd/conf.d/puppetmaster.conf
LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-4.0.21/buildout/apache2/mod_passenger.so
PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-4.0.21
PassengerDefaultRuby /usr/bin/ruby
PassengerHighPerformance On
PassengerUseGlobalQueue On
PassengerMaxPoolSize 4
PassengerMaxRequests 1000
PassengerPoolIdleTime 600

Listen 8140
<VirtualHost *:8140>
    RackAutoDetect On
    DocumentRoot /usr/share/puppet/rack/puppetmasterd/public/
    <Directory /usr/share/puppet/rack/puppetmasterd/>
        Options None
        AllowOverride None
        Order Allow,Deny
        Allow from All
    </Directory>
</VirtualHost>
EOF

echo "ServerName ${FQDN}" >> /etc/httpd/conf/httpd.conf

# stop webrick server
service puppetmaster stop
chkconfig puppetmaster off

# start apache puppetmaster server
service httpd restart

# turn off autosigning
sed -i 's/autosign\ \=\ true/autosign\ \=\ false/g' /etc/puppet/puppet.conf
