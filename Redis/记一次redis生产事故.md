## 背景

####应用服务器redis配置

- maxactive 默认8
- maxidel 100
- timeout 10000ms



####服务器报错信息

![image-20190614164214377](/Users/liujinsheng/Library/Application Support/typora-user-images/image-20190614164214377.png)

####问题分析

服务器内存满了，无法获取memory做rdb

![image-20190614170714027](/Users/liujinsheng/Library/Application Support/typora-user-images/image-20190614170714027.png)

####解决方法

申请增加内存

```
redis.maxactive=1000
redis.maxidle=200
redis.minidle=100
redis.maxwait=2000
redis.timeout=10000   #单位ms
```



#### 配置注意项

- maxactive,maxidel,minidel,maxwait,timeout等参数一定需要合理配置
- 对于redis,mysql,mongo这样的内存服务，生产环境建议关闭swap交换
- 开启redis日志错误日志