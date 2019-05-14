# Nginx根据Http Header转发不同服务器

需求点

- A/B测试，一部分用户采用A版本，一部分用户采用B版本
- 灰度发布

场景假定：

>  根据header中version-header参数值来动态分发请求到不通的应用节点



```nginx
curl -X POST --header  --header 'version-header: v1.0' 'https://demo.com/test'
```

1. 配置nginx可以接收自定义参数的header信息，在http或者server中增加配置项

``` nginx
 underscores_in_headers on;
```

参考nginx官网参数说明:[连接](http://nginx.org/en/docs/http/ngx_http_core_module.html#underscores_in_headers)

2. 配置nginx转发规则

```nginx
 location ^~ /test {
        if ($http_version_header = "v1.0"){
                proxy_pass  https://demo.com/test/;
        }
        proxy_pass  https:demo2.com/test/;
    }
```

3. 测试

```http
curl -X POST --header  --header 'version-header: v1.0' 'https://demo.com/test'
```

该结果将请求正确转发到:https://demo.com/test/

```http
curl -X POST --header  --header 'version-header: v1.0' 'https://demo.com/test'
```

该结果将请求正确转发到:https://demo2.com/test/