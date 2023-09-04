###########################################
#  此程序用于安装指定版本的python以及自定义名称的虚拟环境
#  此程序适用于写入Dockerfile
#  不支持除了bash外的其他shell
###########################################

# 虚拟环境名称
# 虚拟环境名称不随便改了，写进镜像里了
# 后续会编译其他版本的python
VENV_NAME=hdec
# python版本
PYTHON_VERSION=3.9

# 获取当前脚本所在的目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 检查脚本同级目录下是否有miniconda.sh文件
if [ -e "$SCRIPT_DIR/miniconda.sh" ]; then
    echo "miniconda.sh found. Running..."
    bash "$SCRIPT_DIR/miniconda.sh" -b -p $HOME/miniconda
else
    echo "miniconda.sh not found."
    wget -O "$SCRIPT_DIR/miniconda.sh" https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py310_23.5.1-0-Linux-x86_64.sh
    bash "$SCRIPT_DIR/miniconda.sh" -b -p $HOME/miniconda
fi

# conda换成清华源
cat <<EOF > $HOME/.condarc
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  deepmodeling: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/
EOF

# 清除conda缓存
$HOME/miniconda/bin/conda clean -i -y

ls_output=$(ls /root/miniconda/envs/ 2>&1)

# 检查虚拟环境是否已经存在
if [[ "$ls_output" == *"$VENV_NAME"* ]]; then
    echo "虚拟环境$VENV_NAME已存在，退出程序"
    exit 1
fi

# 创建虚拟环境
$HOME/miniconda/bin/conda create -n $VENV_NAME python==$PYTHON_VERSION -y

# 修改pip源(全局)
$HOME/miniconda/envs/$VENV_NAME/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 升级pip
$HOME/miniconda/envs/$VENV_NAME/bin/python -m pip install --upgrade pip

# 初始化bash，默认进入hdec环境
# 暂时只想出这种办法，这样意味着，无法使用VENV_NAME变量
# 有更换名称需求的话，要手动修改下方配置
cat <<'EOF' >> $HOME/.bashrc
__conda_setup="$('/root/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    echo "出现错误，正在退出程序"
fi
unset __conda_setup
eval "conda activate hdec"
EOF

## 其他配置
# vim设置编码格式
cat <<EOF > $HOME/.vimrc
set encoding=utf-8 fileencodings=utf-8
EOF