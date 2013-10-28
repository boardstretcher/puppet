# make sure that you have installed puppet already, using:
# https://github.com/boardstretcher/puppet/blob/master/install_puppet.sh

# mysql setup
yum install -y mysql-server puppet-dashboard
service mysqld start
chkconfig mysqld on
mysql_secure_installation
 
mysql -e "create database puppetdashprod"
mysql -e "create database puppetdashdev"
mysql -e "create database puppetdashtest"
mysql -e "grant all on puppetdashprod.* to 'puppetdashprod'@'localhost' identified by 'puppetdashprod';"
mysql -e "grant all on puppetdashdev.* to 'puppetdashdev'@'localhost' identified by 'puppetdashdev';"
mysql -e "grant all on puppetdashtest.* to 'puppetdashtest'@'localhost' identified by 'puppetdashtest';"
mysql -e "grant all on puppetdashprod.* to 'puppetdashprod'@'%' identified by 'puppetdashprod';"
mysql -e "grant all on puppetdashdev.* to 'puppetdashdev'@'%' identified by 'puppetdashdev';"
mysql -e "grant all on puppetdashtest.* to 'puppetdashtest'@'%' identified by 'puppetdashtest';"
 
# puppetdash config
cat << EOF > /usr/share/puppet-dashboard/config/database.yml
production:
  database: puppetdashprod
  username: puppetdashprod
  password: puppetdashprod
  encoding: utf8
  adapter: mysql

development:
  database: puppetdashdev
  username: puppetdashdev
  password: puppetdashdev
  encoding: utf8
  adapter: mysql

test:
  database: dashboardtest
  username: dashboardtest
  password: dashboardtest
  encoding: utf8
  adapter: mysql
EOF
echo "THOSE TWO SPACES BEFORE EACH LINE MATTER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "So be sure to make sure that each line (not production, development, or test) have two spaces"
echo "before it... I will open up VIM for you to do so. Press enter to open VIM."; read
vim /usr/share/puppet-dashboard/config/database.yml
 
# final setup
cd /usr/share/puppet-dashboard
rake gems:refresh_specs
rake db:migrate RAILS_ENV=production

# workers
service puppet-dashboard start
service puppet-dashboard-workers start

# tests
puppet agent --test --debug --server ${FQDN}
curl -D - ${FQDN}:3000
