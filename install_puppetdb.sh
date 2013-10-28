# assuming everything is working -- which if you used the previous two scripts,
# everything should...

# this will install puppetdb using the puppet module

# lets make sure that the hostname is all good
facter | grep host

# install the module
puppet module install puppetlabs/puppetdb

# use puppet to install puppetdb
puppet resource package puppetdb ensure=latest

# start and enable the service
puppet resource service puppetdb ensure=running enable=true

# check for errors
tail /var/log/puppetdb/puppetdb.log
