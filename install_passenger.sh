# the final piece of the installation
# and the most painful by hand,.. so enjoy the automation of linux!!

yum install -y httpd httpd-devel mod_ssl ruby-devel rubygems gcc make
gem install rack passenger
passenger-install-apache2-module
