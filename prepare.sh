# ONLY TESTED ON Centos 6.4 x86_64


# prepare server for puppet installation

# disable some things, add some better options
echo "" >> /etc/sysctl.conf
echo "# Disable IPV6" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
chkconfig ip6tables off
chkconfig iptables off
sed -i 's/\=enforcing/\=disabled/g' /etc/selinux/config
sed -i 's/DIR\ 01\;34/DIR\ 40\;33/g' /etc/DIR_COLORS
echo "export HISTTIMEFORMAT=\"[%h/%d .. %H:%M:%S] - \"" >> /etc/bashrc
echo "export GREP_OPTIONS='--color=auto'" >> /etc/bashrc
echo "export GREP_COLOR='1;32'" >> /etc/bashrc

# update system, install needed programs
yum update -y
yum install -y vim ntp wget
yum install -y gcc gcc-c++ curl-devel openssl-devel  zlib-devel ruby-devel  httpd-devel apr-devel apr-util-devel

# fix time
ntpdate pool.ntp.org

# most current version (12-Apr-2013)
rpm -ivh https://yum.puppetlabs.com/el/6.4/products/x86_64/puppetlabs-release-6-7.noarch.rpm
rpm -ivh http://mirrors.mit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm

################# reboot!
touch /tmp/prep_done
echo "Press enter to reboot, or CTRL-C to abort installation: "; read; reboot
