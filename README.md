# Openvpn转http代理

由于Openvpn是全局代理，在国内使用时访问国内IP速度慢。所以这里把Openvpn转为http代理。

1. 转换为http代理后，可以使用pac模式，国内IP直连，国外IP代理
2. 浏览器可以使用 SwitchyOmega插件

## 使用方式

```shell
# 构建镜像
docker build -t mxlei/openvpn:1.1.1 .
# 创建容器
docker create \ 
--name openvpn \ 
--cap-add NET_ADMIN \ 
-p 1080:3128 \ 
-v /etc/openvpn/client/Germany2_udp.conf:/root/default.ovpn \ 
-e ovpn=/root/default.ovpn \ 
-e username=xxxx \ 
-e password=xxxx \ 
mxlei/openvpn:1.1.1
# 启动容器
docker start openvpn

# 若要开机自启动
docker update --restart=on-failure:3 openvpn
```

