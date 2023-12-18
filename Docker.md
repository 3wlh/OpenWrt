# 常用Docker
###### 导航
```
docker run \
  --name nginx \
  --restart always \
  -p 8080:80 \
  -v /SD/docker/nginx/www:/usr/share/nginx/html:ro \
  -d nginx
```

###### sun-panel导航
```
mkdir /SD/docker/sun-panel/conf /SD/docker/sun-panel/uploads /SD/docker/sun-panel/database && 
docker run \
  --name sun-panel \
  --restart=always \
  -p 3002:3002 \
  -v /SD/docker/sun-panel/conf:/app/conf \
  -v /SD/docker/sun-panel/uploads:/app/uploads \
  -v /SD/docker/sun-panel/database:/app/database \
  -d hslr/sun-panel
```

###### Alist
```sh
docker run \
  --name alist \
  --restart always \
  -p 5244:5244 \
  -v ~/SD/docker/alist:/opt/alist/data \
  -e PUID=0 -e PGID=0 -e UMASK=022 \
  -d xhofe/alist:latest
```
###### 阅读
```
docker run \
  --name reader \
  --restart always \
  -p 8082:8080 \
  -v /SD/docker/Reader/log:/log \
  -v /SD/docker/Reader/storage:/storage \
  -d hectorqin/reader
```
###### webssh
```
docker run \
  --restart always \
  --name webssh \
  -p 5032:5032
  --net=host \
  --log-driver json-file \
  --log-opt max-file=1 \
  --log-opt max-size=100m \
  -e TZ=Asia/Shanghai \
  -e savePass=true \
  -d jrohy/webssh
```

