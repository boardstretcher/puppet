# assuming everything is working -- which if you used the previous two scripts,
# everything should...

# this will install puppetdb using the puppet module

# clear yum cache
yum clean all

# install the module
puppet module install puppetlabs/puppetdb

# use puppet to install puppetdb
puppet resource package puppetdb ensure=latest --server ${FQDN}

# install sun java (might have to refuckulate this URL)
cd /root/
wget http://javadl.sun.com/webapps/download/AutoDL?BundleId=81811
mv jre* jre-7u45-linux-x64.rpm
rpm -Uvh jre-7u45-linux-x64.rpm
alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000

# config puppetdb
cat << EOF > /etc/puppet/puppetdb.conf
[main]
server = ${FQDN}
port = 8081
EOF
echo "storeconfigs = true" >> /etc/puppet/puppet.conf
echo "storeconfigs_backend = puppetdb" >> /etc/puppet/puppet.conf
echo "reports = store,puppetdb" >> /etc/puppet/puppet.conf

cat << EOF > /etc/puppet/routes.yaml
---
master:
  facts:
    terminus: puppetdb
    cache: yaml
EOF

# make sure puppetdb-terminus is installed
yum -y install puppetdb-terminus

# start and enable the service
puppet resource service puppetdb ensure=running enable=true

# check for errors
tail /var/log/puppetdb/puppetdb.log

# edit 
# puppetdb.conf
# puppet.conf
# routes.yaml
