# installation of activeMQ for mcollective

puppet module install puppetlabs/activemq
puppet resource package activemq ensure=latest --server ${FQDN}
puppet resource service activemq ensure=running enable=true

# that was easy!
