### 配置项

```
character_set_server=utf8mb4    #不要使用utf8，不然无法支持emoj标签存储
lower_case_table_names=1        #标示忽略数据库表名大小写
skip-name-resolve				#
max_connections=1024			#该值需要根据实际情况调整
innodb_buffer_pool_size=4G      #该值建议调整到物理内存的3/4值
innodb_buffer_pool_instances=8  #该值建议设置为数据库的cpu核数
innodb_thread_concurrency=16
datadir=
socker=
innodb_flush_log_at_trx_commit=2
sync_binlog=100
log-bin=mysql-bin

```



### 关闭Swap

```
永久关闭
echo "vm.swappiness = 0">> /etc/sysctl.conf 

执行命令刷新一次SWAP（将SWAP里的数据转储回内存，并清空SWAP里的数据）
swapoff -a && swapon -a

生效配置
sysctl -p 

重启服务
service mysqld restart
```



### 开启mysql err日志

```
log-error=
```

## Mysql内存大小计算
Mysql占用内存大小主要由两部分组成，innodb_buffer_size+连接大小*连接数。
innodb_buffer_size的大小通过参数查询。

每个连接的大小
```
SELECT ( ( @@read_buffer_size
+ @@read_rnd_buffer_size
+ @@sort_buffer_size
+ @@join_buffer_size
+ @@binlog_cache_size
+ @@thread_stack
+ @@net_buffer_length )
) / (1024*1024) AS MEMORY_MB;
```

### 查看innodb的缓存命中率
计算公式:Innodb_buffer_pool_read_requests/(Innodb_buffer_pool_read_requests+Innodb_buffer_pool_read_ahead+Innodb_buffer_pool_reads)
```
mysql> show global status like 'innodb%read%';
+---------------------------------------+------------+
| Variable_name                         | Value      |
+---------------------------------------+------------+
| Innodb_buffer_pool_read_ahead_rnd     | 0          |
| Innodb_buffer_pool_read_ahead         | 246        |   利用后台线程从 innodb buffer 中预读的次数
| Innodb_buffer_pool_read_ahead_evicted | 0          |
| Innodb_buffer_pool_read_requests      | 4715675354 |   从 innodb buffer 中产生的数据读次数
| Innodb_buffer_pool_reads              | 1378       |   从物理磁盘中读数据到 innodb buffer 次数
| Innodb_data_pending_reads             | 0          |
| Innodb_data_read                      | 28790784   |   读书字节数
| Innodb_data_reads                     | 1400       |   读取请求数（一次可能读入多页）
| Innodb_pages_read                     | 1623       |
| Innodb_rows_read                      | 4655914819 |
+---------------------------------------+------------+
10 rows in set (0.01 sec)
```


### 查询缓存

```\query_cache_size=128M
query_cache_size=128M  #该参数不能设置的过大，最大不能超过128M
query_cache_type=ON
```

### 慢查询

```
参数
slow_query_log=ON
log_slow_queries       = /var/log/mysql/mysql-slow.log
long_query_time = 2
log-queries-not-using-indexes

不停服务启用
SET GLOBAL slow_query_log = 'ON';
```

## QA

### 查询缓存命中率查看

Mysql的查询缓存命中率 ≈ qcache_hits / (qcache_hits + com_select)

- com_select查询

```mysql
mysql> show global status like 'Com_select';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| Com_select    | 46    |
+---------------+-------+
```

- Qcache_hits查询

```
mysql> show global status like 'QCache%'
+-------------------------+----------+
| Variable_name           | Value    |
+-------------------------+----------+
| Qcache_free_blocks      | 1        |
| Qcache_free_memory      | 18856920 |
| Qcache_hits             | 3        |
| Qcache_inserts          | 20       |
| Qcache_lowmem_prunes    | 0        |
| Qcache_not_cached       | 26       |
| Qcache_queries_in_cache | 0        |
| Qcache_total_blocks     | 1        |
+-------------------------+----------+
```

- 结果：  查询缓存命中率约为： 3/(3+46) = 6.12%



#### 查询缓存变量含义



| 参数                    | 含义                                                         |
| ----------------------- | ------------------------------------------------------------ |
| Qcache_free_blocks      | 目前还处于空闲状态的 Query Cache中内存 Block 数目，数目大说明可能有碎片。FLUSH QUERY CACHE会对缓存中的碎片进行整理，从而得到一个空闲块。 |
| Qcache_free_memory      | 缓存中的空闲内存总量。                                       |
| Qcache_hits             | 缓存命中次数。                                               |
| Qcache_inserts          | 缓存失效次数。                                               |
| Qcache_lowmem_prunes    | 缓存出现内存不足并且必须要进行清理以便为更多查询提供空间的次数。这个数字最好长时间来看；如果这个数字在不断增长，就表示可能碎片非常严重，或者内存很少。（上面的free_blocks和free_memory可以告诉您属于哪种情况）。 |
| Qcache_not_cached       | 不适合进行缓存的查询的数量，通常是由于这些查询不是SELECT语句以及由于query_cache_type设置的不会被Cache的查询 |
| Qcache_queries_in_cache | 当前缓存的查询（和响应）的数量。                             |
| Qcache_total_blocks     | 缓存中块的数量。                                             |
