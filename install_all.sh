# tested on Scientific Linux 6.4 x64
 
# for a clean minimal installation and configuration of SL6,
# see this gist: https://gist.github.com/boardstretcher/6655517
 
echo "hostname: ${HOSTNAME}"
echo "domain: ${DOMAIN}"
echo "if empty, you want to set it in network/hosts and reboot (FQDN), or set them manually"
echo "with export"

# most current version (12-Apr-2013)
rpm -ivh https://yum.puppetlabs.com/el/6.4/products/x86_64/puppetlabs-release-6-7.noarch.rpm
rpm -ivh http://mirrors.mit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm

# update system, install needed programs
yum update -y
yum install -y vim ntp wget openssh-clients

# fix time
ntpdate pool.ntp.org

################# reboot!
sleep 10; reboot
 
# install puppet programs
yum install -y puppet-server puppetdb-terminus puppetdb puppet-dashboard mysql mysql-server
 
# configure puppet
echo "*" > /etc/puppet/autosign.conf
 
cat << EOF > /etc/puppet/puppetdb.conf
[main]
server = ${HOSTNAME}
port = 8081
EOF
 
cat << EOF > /etc/puppet/routes.yaml
---
master:
facts:
terminus: puppetdb
cache: yaml
EOF
 
cat << EOF > /etc/puppet/puppet.conf
[master]
storeconfigs = true
storeconfigs_backend = puppetdb
EOF
 
puppet cert --generate ${HOSTNAME}
rm -f /var/lib/puppet/ssl/certs/localhost.localdomain.pem
/usr/sbin/puppetdb-ssl-setup
service puppetmaster start
service puppetdb start
chkconfig puppetdb on
chkconfig puppetmaster on
 
cat << EOF > /etc/puppet/fileserver.conf
[files]
path /etc/puppet/files
allow *.${DOMAIN}
EOF
 
service mysqld start
chkconfig mysqld on
mysql_secure_installation
mysql -u root -e "CREATE DATABASE dashboard";
mysql -u root -e "CREATE DATABASE dashboard_dev";
mysql -u root -e "GRANT ALL PRIVILEGES ON dashboard.* TO dashboard@localhost IDENTIFIED BY 'somepassword';"
mysql -u root -e "GRANT ALL PRIVILEGES ON dashboard_dev.* TO dashboard_dev@localhost IDENTIFIED BY 'somepassword';"
 
cat << EOF > /usr/share/puppet-dashboard/config/database.yml
production:
database: dashboard
username: dashboard
password: somepassword
encoding: utf8
adapter: mysql
development:
database: dashboard_dev
username: dashboard_dev
password: somepassword
encoding: utf8
adapter: mysql
EOF
