# installation of mcollective

puppet module install puppetlabs/mcollective
puppet resource package mcollective ensure=latest --server ${FQDN}
puppet resource service mcollective ensure=running enable=true

