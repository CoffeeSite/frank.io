## Nginx Sample

```nginx
user  nginx;   --已nginx用户运行
worker_processes 8;     --worker线程数，通常为cpu的核数
worker_rlimit_nofile 65535;    --nginx最大能打开的文件句柄数

#error_log  /var/log/nginx/error.log warn;
error_log  /home/eoop/nginx/log/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  65535;    --worker的最大连接数
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /home/eoop/nginx/log/access2.log  main;
    #access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;
    client_max_body_size  10m;

    gzip  on;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    include /etc/nginx/conf.d/eoop.conf;
   	
  	server {
      listen       443;
      listen       80;
      server_name  localhost;
      large_client_header_buffers 4 16k;
      client_max_body_size 600m;
      client_body_buffer_size 512k;
      proxy_connect_timeout 600;
      proxy_read_timeout 600;
      proxy_send_timeout 600;
      proxy_buffer_size 64k;
      proxy_buffers 4 32k;
      proxy_busy_buffers_size 64k;
      proxy_temp_file_write_size 128k;
      charset utf-8;
      ssl on;
      ssl_certificate /etc/nginx/cert/cert.pem;
      ssl_certificate_key /etc/nginx/cert/cert.key;

      #charset koi8-r;
      #access_log  /home/logs/nginx/host.access.log  main;

    	upstream apiHost {
          server 127.0.0.1:8080;
      		server 127.0.0.2:8080;
      }
      
      location /i {
          deny all;
          access_log off;
          error_log off;
      }
    	
    	location /h5 {
        alias /etc/nginx/modules/h5;
        expires -1;   #设置nginx过期时间,-1表示不开启缓存(2min,2d)
    	}

    	location /download {
         rewrite ^/  http://demo.com:8090/download.html;  #将指定连接重写连接
   		}
    	
     location = /download/fullList.json {
        proxy_pass  http://downloadServerHost/download/fullList.json; #将制定连接重写连接
     }

    	
    	location /api {
        add_header 'Access-Control-Allow-Origin' '*';
        add_header Access-Control-Allow-Headers "Origin, X-Requested-With, Content-Type, 	  Accept,token";
        proxy_pass  http://apiHost/api;
    }
  
}
```

