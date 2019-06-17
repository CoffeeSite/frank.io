## 

### Docker

- docker-install.sh

  ```shell
  ./docker-install.sh
  ```

1. 停止并删除先有的docker，默认删除路径为：/var/lib/docker/
2. 安装docker-ce-18.03.1.ce版本
3. 创建docker网桥：182.168.1.5

- docker-enter.sh

  ```
  ./docker-enter container_name   #container_name为需要进入的容器名
  ```

此命令用于进入到docker容器内

### Mongodb

```
./mongo-install.sh
```

此命令用于安装mongodb-org-3.4版本。

安装后，请修改/etc/mongo.conf文件的bindIp参数。

### Nginx 
### Redis

### SyncTime

