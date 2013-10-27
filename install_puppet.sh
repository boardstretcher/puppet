# this will install puppet-master correctly, from there it is possible to 
# use manifests to install puppetdb, activemq and the rest.

# /etc/sysconfig/network
# /etc/hosts
echo "FQDN hostname of server: "; read HOSTNAME
echo "Just the domain now: "; read DOMAIN
echo "a general mysqlpassword: "; read MYSQLPASSWORD

# disable some things, add some better options
echo "" >> /etc/sysctl.conf
echo "# Disable IPV6" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
chkconfig ip6tables off
chkconfig iptables off
sed -i 's/\=enforcing/\=disabled/g' /etc/selinux/config
sed -i 's/DIR\ 01\;34/DIR\ 40\;33/g' /etc/DIR_COLORS
echo "export HISTTIMEFORMAT=\"[%h/%d .. %H:%M:%S] - \"" >> /etc/bashrc
echo "export GREP_OPTIONS='--color=auto'" >> /etc/bashrc
echo "export GREP_COLOR='1;32'" >> /etc/bashrc

# fix time
ntpdate pool.ntp.org

# most current version (12-Apr-2013)
rpm -ivh https://yum.puppetlabs.com/el/6.4/products/x86_64/puppetlabs-release-6-7.noarch.rpm
rpm -ivh http://mirrors.mit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm

################# reboot!
echo "Press enter to reboot, or CTRL-C to abort installation: "; read; reboot
 
# update system, install needed programs
yum update -y
yum install -y vim ntp puppet-server

# configure puppet master
cat << EOF > /etc/puppet/puppet.conf
[main]
    logdir = /var/log/puppet
    rundir = /var/run/puppet
    ssldir = $vardir/ssl
[agent]
    classfile = $vardir/classes.txt
    localconfig = $vardir/localconfig
[master]
    certname = ${HOSTNAME}
    autosign = true
EOF

# config the puppet client
cat << EOF > /etc/sysconfig/puppet
PUPPET_SERVER=${HOSTNAME}
PUPPET_LOG=/var/log/puppet/puppet.log
EOF

# configure fileserver, make test manifest
mkdir -p /opt/puppet-fileserver
mkdir -p /etc/puppet/manifests/classes

echo "nothing" > /opt/puppet-fileserver/nothing

cat << EOF > /etc/puppet/fileserver.conf
[files]
path /opt/puppet-fileserver
allow *.${DOMAIN}
EOF

cat << EOF > /etc/puppet/manifests/side.pp
import "classes/*"
node default {
include test
}
EOF

cat << EOF > /etc/puppet/manifests/classes/test.pp
class test {
file { "/tmp/nothing":
owner => root,
group => root,
mode => 644,
source => "puppet:///files/nothing"
}
}
EOF

# start, create cert for server
puppet cert --generate ${HOSTNAME}
service puppetmaster restart
service puppet restart
chkconfig puppetmaster on
chkconfig puppet on
