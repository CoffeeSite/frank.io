

## BIO/NIO/APR模式

```xml
<Connector port="9040" protocol="org.apache.coyote.http11.Http11NioProtocol"
               connectionTimeout="20000"
               maxThreads="1000" acceptCount="1000"  
               redirectPort="8443" URIEncoding="UTF-8"/>
```

maxThreads 控制最大线程数

acceptCount 最大线程等待数

connectionTimeout(单位毫秒)  连接超时配置 



## 通过tomcat进行路径代理，这种方式目前已不建议使用，可以用代理服务器实现

```xml
<Context path="/download" docBase="/home/eoop/download" reloadable="true" debug="0"/>
```





## JVM策略

### 回收策略

https://zhuanlan.zhihu.com/p/269597178



### 内存溢出快照设置

-XX:+HeapDumpOnOutOfMemory” 和 “-XX:HeapDumpPath=/data/jvm/dumpfile.hprof
```java
-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=./logs/gc.hprof -Djava.security.egd=file:/dev/./urando
```



```java
java -Dlog4j2.formatMsgNoLookups=true  -Xms1280m -Xmx2560m -Djava.security.egd=file:/dev/./urandom      -Dserver.tomcat.max-threads:1000 -Dserver.tomcat.max-connections:20000 -Dserver.tomcat.accept-count:200        -Dcom.sun.management.jmxremote        -Dcom.sun.management.jmxremote.port=39014        -Dcom.sun.management.jmxremote.local.only=false        -Dcom.sun.management.jmxremote.authenticate=false        -Dcom.sun.management.jmxremote.ssl=false       -Djava.rmi.server.hostname=172.17.1.241    -jar eopx-dms-biz.jar
```



## 内存配置

JAVA_OPTS="-Xms2048m -Xmx4096m -Xss2048K -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=768m -Dfile.encoding=UTF8 -Dsun.jnu.encoding=UTF8"



## 日志分隔 cronlog 

/usr/local/sbin/cronolog "$CATALINA_BASE"/logs/catalina.%Y-%m-%d.out >>/dev/null





