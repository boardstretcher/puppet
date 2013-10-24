# tested on Scientific Linux 6.4 x64

# for a clean minimal installation and configuration of SL6,
# see this gist: https://gist.github.com/boardstretcher/6655517

echo "set these variables"

echo "hostname: ${HOSTNAME}"
echo "domain: ${DOMAIN}"

echo "then edit this script and change any instance of 'somepassword' to something else"
echo "then remove exit; from this file and run it"

exit;

# most current version (12-Apr-2013)
rpm -ivh https://yum.puppetlabs.com/el/6.4/products/x86_64/puppetlabs-release-6-7.noarch.rpm
rpm -ivh http://mirrors.mit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm

# update system, install needed programs
yum update -y
yum install -y vim ntp

# fix time
ntpdate pool.ntp.org

################# reboot!
sleep 10; reboot
 
yum -y install puppet-server

cat << EOF > /etc/puppet/puppet.conf
[main]
logdir = /var/log/puppet
rundir = /var/run/puppet
ssldir = $rundir/ssl
[agent]
classfile = $rundir/classes.txt
localconfig = $rundirr/localconfig
[master]
certname = ${HOSTNAME}
autosign = true
EOF

echo "*" > /etc/puppet/autosign.conf
echo "PUPPET_SERVER=${HOSTNAME}" > /etc/sysconfig/puppet

service puppetmaster restart
puppet cert --generate ${HOSTNAME}

