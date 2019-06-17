yum install -y ntp
chkconfig ntpd on
/usr/sbin/ntpdate pool.ntp.org

/etc/init.d/ntpd start

