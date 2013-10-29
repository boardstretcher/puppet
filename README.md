puppet 3.3.1 installation
======

THESE SCRIPTS WORK!!

Tested on Centos 6.4 x86_64 - October 28, 2013

I made them because the documentation of installation process for Puppet Community is frankly fucking laughable. 
And worse yet, its a RUBY program, so the debugging process is deplorable. So If you are ready to tear your hair 
out because you need an actual working install, which is asking for a lot from Community Puppet, then these 
are the scripts you need.

You are welcome.

PRE-SETUP REQUIREMENTS
======

the most important thing in the puppet world is HOSTNAME setup.

- add your puppetmaster FQDN to your DNS server if you have one
- modify your /etc/hosts file to include your puppetmaster FQDN
- modify your /etc/sysconfig/network file to include your puppetmaster FQDN

The installation script will ask you for the required FQDN for installation, but it will not set up
the above files for you.

installation on Centos 6.4 x86_64
======

**You should install in this order**

install_puppet.sh           - install the basic puppet master, client and puppet fileserver

install_dashboard.sh        - install a basic puppet dashboard running on webrick @ port 3000

install_puppetdb.sh         - install the puppetdb and configure it for use by dashboard and puppet master

install_puppet_activemq.sh  - install activemq for use with mcollective

install_mco.sh              - install mcollective
