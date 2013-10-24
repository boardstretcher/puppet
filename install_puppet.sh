# most importantly, make sure your hostname and domain is set and correct
# /etc/sysconfig/network
# /etc/hosts
echo "hostname: ${HOSTNAME}"
echo "mysqlpassword: ${MYSQLPASSWORD}"
echo "if empty, you want to set it in network/hosts and reboot"
 
# most current version (12-Apr-2013)
rpm -ivh https://yum.puppetlabs.com/el/6.4/products/x86_64/puppetlabs-release-6-7.noarch.rpm
rpm -ivh http://mirrors.mit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm
 
# update system, install needed programs
yum update -y
yum install -y vim ntp
 
# fix time
ntpdate pool.ntp.org
 
################# reboot!
sleep 10
 
# install puppet, client and dashboard
yum install -y puppet-server puppetdb-terminus puppetdb
 
# config the puppetmaster
echo "PUPPET_SERVER=${HOSTNAME}" > /etc/sysconfig/puppet
echo "PUPPET_LOG=/var/log/puppet/puppet.log" >> /etc/sysconfig/puppet
echo "PUPPET_EXTRA_OPTS=--waitforcert=60" >> /etc/sysconfig/puppet
echo "*" > /etc/puppet/autosign.conf

# puppet db config
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
[main]
logdir = /var/log/puppet
rundir = /var/run/puppet
ssldir = /etc/puppet/ssl
[agent]
classfile = /etc/puppet/classes.txt
localconfig = /etc/puppet/localconfig
[master]
storeconfigs = true
storeconfigs_backend = puppetdb
EOF

# start, create cert
service puppetmaster restart
puppet cert --generate ${HOSTNAME}
/usr/sbin/puppetdb-ssl-setup
service puppetdb restart
service puppetmaster restart
chkconfig puppetmaster on
chkconfig puppetdb on

mkdir /etc/puppet/files
chown -R puppet.puppet /etc/puppet

# set up fileserver
cat << EOF > /etc/puppet/fileserver.conf
[files]
path /etc/puppet/files
allow *.${DOMAIN}
EOF

yum install -y puppet-dashboard mysql mysql-server
chkconfig mysqld on 
service mysqld start
mysql -u root -e "CREATE DATABASE dashboard";
mysql -u root -e "GRANT ALL PRIVILEGES ON dashboard.* TO dashboard@localhost IDENTIFIED BY '${MYSQLPASSWORD}';"

