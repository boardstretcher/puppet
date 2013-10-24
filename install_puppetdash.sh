# make sure that you have installed puppet already.

# mysql setup
yum install -y mysql-server puppet-dashboard
service mysqld start
chkconfig mysqld on
mysql_secure_installation
 
mysql -e "create database puppetdash"
mysql -e "grant all on puppetdash.* to puppetdash@localhost identified by 'BHbdhbD938UIH222';"
 
# puppetdash config
cat << EOF > /usr/share/puppet-dashboard/config/database.yml
production:
database: puppetdash
username: puppetdash
password: BHbdhbD938UIH222
encoding: utf8
adapter: mysql
development:
database: puppetdash
username: puppetdash
password: BHbdhbD938UIH222
encoding: utf8
adapter: mysql
test:
database: dashboard_test
username: dashboard
password:
encoding: utf8
adapter: mysql
EOF
 
# final setup
cd /usr/share/puppet-dashboard
rake RAILS_ENV=production db:migrate
/etc/init.d/puppet-dashboard start
 
# workers
sudo -u puppet-dashboard env RAILS_ENV=production script/delayed_job -p dashboard -n 4 -m start
 
# tests
puppet agent --test
curl -D - ${HOSTNAME}:3000
