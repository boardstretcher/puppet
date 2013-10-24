# most importantly, make sure your hostname and domain is set and correct
# /etc/sysconfig/network
# /etc/hosts
echo "hostname: ${HOSTNAME}"
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
yum install -y puppet-server
 
# config the puppetmaster
echo "PUPPET_SERVER=${HOSTNAME}" > /etc/sysconfig/puppet
echo "PUPPET_LOG=/var/log/puppet/puppet.log" >> /etc/sysconfig/puppet
echo "PUPPET_EXTRA_OPTS=--waitforcert=60" >> /etc/sysconfig/puppet
 
# start, create cert
service puppetmaster start
puppet cert --generate ${HOSTNAME}
