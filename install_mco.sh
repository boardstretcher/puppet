# installation of mcollective

puppet module install puppetlabs/mcollective
puppet resource package mcollective ensure=latest --server ${FQDN}
puppet resource package mcollective-client ensure=latest --server ${FQDN}
puppet resource service mcollective ensure=running enable=true

sed -i "s/localhost/${FQDN}/g" /etc/mcollective/server.cfg
sed -i "s/localhost/${FQDN}/g" /etc/mcollective/client.cfg

service puppetmaster restart
service puppetdb restart
service activemq restart
service mcollective restart

service puppetmaster status
service puppetdb status
service activemq status
service mcollective status

