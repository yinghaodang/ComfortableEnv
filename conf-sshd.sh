mkdir /root/.ssh/

# 设置自己的公钥
PUBLIC_KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN78nZbO3IapnSIM0T6Thdpe4z0KL2j22g2lQgzi1v6vL9iBigvOPX3WNGBBxnADZ+7eL7d8w8vEZmXxQKM3xeDk3R+G4m7MqbcyVORnCmFF3Y4x61u0w4nVn8iH8iLnz0xyFEDNd92/PCR9JO4oeCVHEjl/D8cCHkVErExPbyDKjW2+bv9yfvGq5oFCSnGZkup2UQ+BP+5iORa85Zf72WRRTCzuZ1jErpRDtf70QrdEqeKx/psRVzMfwsAhMNwcySPAVyFx7uIt/q5uR4HxRByC8xc7zmegc/kj6tRXnM2OK1xkOUe7fm0p43oYYlknmu1x7x2O0eGvVW3DYM1tdX 2532611359@qq.com'
tee -a /root/.ssh/authorized_keys <<EOF
$PUBLIC_KEY
EOF

# 设置容器密码，默认12345
# 仅在安全环境下使用
PASSWD=12345
echo "root:$PASSWD" | chpasswd

# 设置sshd接受root登录
# 设置sshd接受公钥登录
tee -a /etc/ssh/sshd_config <<EOF
PermitRootLogin yes
PubkeyAuthentication yes
EOF

# 一般来说是服务未启动的
if service ssh status | grep -q "is running"; then
    # 重启sshd服务
    service ssh restart
else
    # 启动sshd服务
    service ssh start
fi
