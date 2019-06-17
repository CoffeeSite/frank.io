echo "[mongodb-org-3.4]" > /etc/yum.repos.d/mongodb-org-3.4.repo
echo "name=MongoDB Repository"   >> /etc/yum.repos.d/mongodb-org-3.4.repo
echo 'baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/' >> /etc/yum.repos.d/mongodb-org-3.4.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/mongodb-org-3.4.repo
echo "enabled=1" >> /etc/yum.repos.d/mongodb-org-3.4.repo
echo "gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc" >> /etc/yum.repos.d/mongodb-org-3.4.repo

sudo yum install -y mongodb-org

sudo chkconfig mongod on

sudo service mongod start
