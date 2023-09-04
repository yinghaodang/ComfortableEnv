# 我的一份Dockerfile

1. 基于英伟达镜像编译，可以去Dockerhub选择合适的基础镜像

2. 内置多种方便调试的Linux工具，支持VScode远程登录容器调试

3. 支持更改miniconda

这份Dockerfile还不太成熟，我加了一些不太好用的功能，比如说创建虚拟环境。
但这其实并不好研究清楚，`conda activate xxx`,这条命令做了什么得先去看明白。

转念一想，没必要虚拟环境，更换编译镜像时使用的miniconda文件即可。
