# 我的一份Dockerfile

## 基本介绍

1. 基于英伟达镜像编译，可以去Dockerhub选择合适的基础镜像

2. 内置多种方便调试的Linux工具，支持VScode远程登录容器调试

3. 支持更改miniconda链接，达到更改conda版本和python版本的目的，随版本替换

## 一些细节

我设置了软链接，这样就可以在docker exec <container id> 后直接接python了
我还是不太清楚，如果后期Dockerfile要添加环境变量，肯定不能写在/root/.bashrc里面

或者使用Dockerfile的写法：ENV PATH="${PATH}:/usr/local/bin/python"
但为了Dockerfile尽可能简洁，我把这部分写进了sh文件中，/usr/bin/这个目录层级很高。

## 启用远程调试

启动容器的时候提前开放22端口到主机，主机端口任意，尽量大一点的端口

运行 bash /root/conf-sshd.sh 启动sshd服务

密码默认是sshd，也可修改conf-sshd.sh，添加自己的公钥，方便登录