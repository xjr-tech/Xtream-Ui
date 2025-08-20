# 创建启用root的脚本
sudo tee /home/ubuntu/enable_root.sh > /dev/null << 'EOF'
#!/bin/bash

echo "正在启用root用户..."

# 设置root密码
echo "请设置root密码:"
sudo passwd root

# 备份SSH配置
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# 修改SSH配置
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# 如果没有找到PermitRootLogin行，则添加
if ! grep -q "PermitRootLogin" /etc/ssh/sshd_config; then
    echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
fi

# 确保密码认证启用
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 重启SSH服务
sudo systemctl restart ssh

echo "root用户已启用！"
echo "当前SSH配置："
sudo grep -E "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd_config

echo "请在新终端测试root登录，确认成功后再关闭当前会话！"
EOF