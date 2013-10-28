# assuming everything is working -- which if you used the previous two scripts,
# everything should...

# this will install puppetdb using the puppet module

# lets make sure that the hostname is all good
facter | grep host

echo "That hostname should be a FQDN, if it is not, then exit this installation";
echo "and set your /etc/hosts, /etc/sysconfig/network files to have the FQDN and reboot";
echo ""
echo "Press enter to coninute or CTLR-C to quit and make changes"; read

# install the module
puppet module install puppetlabs/puppetdb

# use puppet to install puppetdb
puppet resource package puppetdb ensure=latest

# start and enable the service
puppet resource service puppetdb ensure=running enable=true

# check for errors
tail /var/log/puppetdb/puppetdb.log

# edit 
# puppetdb.conf
# puppet.conf
# routes.yaml
