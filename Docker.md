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
mkdir -p /mnt/SD/Configs/SunPanel/conf && 
docker run \
  --name sun-panel \
  --restart=always \
  -p 3002:3002 \
  -v /mnt/SD/Configs/SunPanel/conf:/app/conf \
  -d hslr/sun-panel
```
###### DSM
```
docker run \
  -it \
  --rm \
  --name DSM \
  -p 4000:5000 \
  -v /SD/docker/dsm:/storage \
  -e DISK_SIZE=8G \
  -e CPU_CORES=4 \
  --device=/dev/kvm \
  --cap-add NET_ADMIN \
  --stop-timeout 60 \
  vdsm/virtual-dsm:latest
```
CHECKSUM checksum

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
  --name=Reader \
  --restart=always \
  -e "SPRING_PROFILES_ACTIVE=prod" \
  -v /SD/docker/Reader/logs:/logs \
  -v /SD/docker/Reader/storage:/storage \
  -p 8082:8080 \
  -d hectorqin/reader
```
###### webssh
```
docker run \
  --restart always \
  --name webssh \
  -p 5032:5032 \
  --log-driver json-file \
  --log-opt max-file=1 \
  --log-opt max-size=100m \
  -e TZ=Asia/Shanghai \
  -e savePass=false \
  -d jrohy/webssh
```
```
# 设置密码
docker run \
  --restart always \
  --name webssh \
  -p 5032:5032 \
  --net=host \
  --log-driver json-file \
  --log-opt max-file=1 \
  --log-opt max-size=100m \
  -e TZ=Asia/Shanghai \
  -e savePass=true \
  -e authInfo=3wlh:199711 \
  -d jrohy/webssh
```