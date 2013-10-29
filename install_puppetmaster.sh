# some variables to fill
echo "JUST hostname of server: "; read HOSTNAME
echo "JUST the domain now: "; read DOMAIN
echo "Now the WHOLE FQDN: "; read FQDN
echo "a general mysqlpassword: "; read MYSQLPASSWORD

# install puppet
yum install -y puppet-server
 
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
    certname = ${FQDN}
    autosign = true
EOF

# config the puppet client
cat << EOF > /etc/sysconfig/puppet
PUPPET_SERVER=${FQDN}
PUPPET_LOG=/var/log/puppet/puppet.log
EOF

# configure fileserver, make test manifest
mkdir -p /opt/puppet-fileserver
mkdir -p /etc/puppet/manifests/classes
mkdir -p /etc/puppet/manifests/nodes
echo "nothing" > /opt/puppet-fileserver/nothing

chown -R puppet.puppet /opt/puppet-fileserver

cat << EOF > /etc/puppet/fileserver.conf
[files]
path /opt/puppet-fileserver
allow *
EOF

# configure default manifest
cat << EOF > /etc/puppet/manifests/site.pp
import "classes/*"
node default {
}
EOF

# configure puppetmaster manifest
cat << EOF > /etc/puppet/manifests/nodes/${HOSTNAME}.pp
node '${HOSTNAME}' {
  include test
}
EOF

# create fileserver test manifest
cat << EOF > /etc/puppet/manifests/classes/test.pp
class test {
 file { "/tmp/nothing":
 owner => root,
 group => root,
 mode => 644,
 source => "puppet://${FQDN}/files/nothing"
}
}
EOF

# start, create cert for server
service puppetmaster restart
service puppet restart
chkconfig puppetmaster on
chkconfig puppet on
puppet cert --generate ${FQDN}
puppet cert clean ${HOSTNAME}
rm -f /ssl/certs/${HOSTNAME}.pem

# test
puppet agent --test --debug --server ${FQDN}
