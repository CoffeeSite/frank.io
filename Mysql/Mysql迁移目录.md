Mysql迁移目录

####数据文件目录迁移

```
cp -aR /var/lib/mysql/ /home/eoop/
```

#### 配置文件修改

```mysql
vim /etc/my.cnf.d/server.cnf
[mysqld]
datadir=/home/eoop/mysql
socket=/home/eoop/mysql/mysql.sock
innodb_flush_log_at_trx_commit=2
sync_binlog=100
log-bin=mysql-bin


vim /etc/my.cnf.d/mysql-clients.cnf
[mysql]
socket=/home/eoop/mysql/mysql.sock
```

#### 删除多余文件

```
rm -rf /home/eoop/mysql/ib_logfile0
rm -rf /home/eoop/mysql/ib_logfile1
```



#### 保护目录修改
Mysql默认不允许迁移到home目录，如果需要到home目录，需要修改如下配置

```
vim /usr/lib/systemd/system/mariadb.service
# Prevent writes to /usr, /boot, and /etc
ProtectSystem=
# Prevent accessing /home, /root and /run/user
ProtectHome=
```



####重启

```
systemctl daemon-reload
systemctl start mysqld
```

