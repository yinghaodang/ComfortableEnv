FROM nvidia/cuda:11.4.3-devel-ubuntu20.04

# 以非交互式地方式安装
ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i s/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        iputils-ping \
        net-tools \
        curl \
        telnet \
        wget \
        unzip \
        vim \
        openssh-server \
        openssh-client \
        git && \
    rm -rf /var/lib/apt/lists/*  # 清理APT缓存

COPY python-build.sh conf-sshd.sh /root/

# 切换到bash环境
SHELL ["/bin/bash", "-c"]

# 安装miniconda, bash应该也是可以的
RUN bash /root/python-build.sh

# 开放22端口
EXPOSE 22

# 解决编码问题
ENV LANG=C.UTF-8

# 配置sshd服务并启动
CMD bash /root/conf-sshd.sh
