# installation of mcollective

puppet module install puppetlabs/mcollective
puppet resource package mcollective ensure=latest --server ${FQDN}
puppet resource package mcollective-client ensure=latest --server ${FQDN}
puppet resource service mcollective ensure=running enable=true

sed -i "s/localhost/${FQDN}/g" /etc/mcollective/server.cfg
service mcollective restart


