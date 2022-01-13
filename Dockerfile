# Openvpn转http代理
# 由于Openvpn是全局代理，在国内使用时访问国内IP速度慢。所以这里把Openvpn转为http代理
# 转换为http代理后，可以使用pac模式，国内IP直连，国外IP代理
# 浏览器可以使用 SwitchyOmega插件
# 使用方式： 
#        docker build -t mxlei/openvpn:1 .
#        docker create --name openvpn --cap-add NET_ADMIN -p 1080:3128 -v /etc/openvpn/client/Germany2_udp.conf:/root/default.ovpn -e ovpn=/root/default.ovpn -e username=xxxx -e password=xxxx mxlei/openvpn:1
#        docker start openvpn

FROM ubuntu:20.04
LABEL maintainer=mxlei

RUN echo "Openvpn to http convert"

# openvpn的配置文件、用户凭证
ENV ovpn=/etc/openvpn/client/default.ovpn
ENV username=
ENV password=
# 解决tzdata包安装时输入时区问题
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 使用国内软件源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bk
COPY build/sources.list /etc/apt/sources.list

# 安装需要的软件包
RUN apt-get update
RUN apt-get install -y openvpn squid

# http监听的默认端口，容器外部映射到此端口
EXPOSE 3128
RUN sed -i "s/http_access deny all/http_access allow all/" /etc/squid/squid.conf 

WORKDIR /root
COPY build/start.sh /root/
RUN chmod 500 /root/start.sh

CMD ["/bin/bash", "/root/start.sh"]
