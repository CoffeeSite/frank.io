### 机器准备

| IP           | OS         | Name      |
| :----------- | ---------- | --------- |
| 172.20.31.12 | CentOS 7.2 | db-Master |
| 172.20.10.53 | CentOS 7.2 | db-Slave1 |
| 172.20.177.0 | CentOS 7.2 | db-Slave2 |

**分别在三台机器上继续如下设置**



### Linux系统常用设置

- 关闭 Selinux
- 关闭 防火墙
- 设置最大文件句柄数
- 时间自动同步



### 添加源：MariDB.repo

```
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
```



### 通过YUM进行安装

```
sudo yum install MariaDB-server MariaDB-client
```



### 启动&初始化配置

```
systemctl start mariadb.service
mysql_secure_installation
```



### 配置参数开启Galera

```
wsrep_on=ON
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address=gcomm://db-master,db-slave1,db-slave2
binlog_format=row
default_storage_engine=InnoDB
```



### 关闭数据器&以Galera形式启动

- 在db-master节点执行: 

  ```
  mysqld --wsrep-new-cluster --user=root &
  ```

- 在其他节点（新节点）执行: 

  ```
  systemctl start mariadb 
  ```

- 当集群中已经有数据，需要新增节点:

  ```
  mysqld --wsrep_cluster_address=gcomm://db-master --user=root
  ```

  > 注意，仅且仅有在一个节点上能执行：mysqld --wsrep-new-cluster --user=root &, 当前命令表示开启一个新的galera集群，其他节点通过政策启动加入当前节点并同步数据

### 集群验证

