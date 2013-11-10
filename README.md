If you have any improvements, be sure to fork/pull the changes up! I'm always looking for improvement. Don't bother 
complaining about the scripts, or my methods. If you don't like them, contribute code and fixes, and put your money where your
mouth is. Complaining doesn't fix a fucking thing.

puppet 3.3.1 installation
======

NOTE:

(I sacrifice security for automation, so on a production system be sure to re-enable iptables, selinux, 
and change your passwords. This is more of a proof-of-concept to get puppet up and running correctly. Once you see
that its possible and how it is done, it is much easier to have security enabled and go through the process
on your own, or tailor the scripts to suit your needs.)

ANYWAY:

These scripts actually work!

Tested on Centos 6.4 x86_64 - October 28, 2013

I made them because the documentation of installation process for Puppet Community is frankly fucking laughable. 
And worse yet, its a RUBY program, so the debugging process is deplorable. So If you are ready to tear your hair 
out because you need an actual working install, which is asking for a lot from Community Puppet, then these 
are the scripts you need to start with.

You are welcome.

Coming soon
======
A few people mentioned that they want "external node classifiers" enabled, Ill work that in this week.

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

- prepare.sh                  - prepare the server for installation
- install_puppetmaster.sh     - install the basic puppet master, client and puppet fileserver
- install_dashboard.sh        - install a basic puppet dashboard running on webrick @ port 3000
- install_puppetdb.sh         - install the puppetdb and configure it for use by dashboard and puppet master
- install_puppet_activemq.sh  - install activemq for use with mcollective
- install_mco.sh              - install mcollective
- install_passenger.sh        - install passenger and disable webrick
