#!/bin/bash

## !IMPORTANT ##
#
## This script is tested only in the ubuntu/focal64 Vagrant box
## If you use a different version of Ubuntu or a different Ubuntu Vagrant box test this again
#
echo "[TASK 1] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "[TASK 2] Stop and Disable firewall"
systemctl disable --now ufw >/dev/null 2>&1

echo "[TASK 3] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 4] Set root password"
echo -e "1\n1" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc

echo "[TASK 5] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.56.10   kmaster
192.168.56.11   kworker1
EOF

# echo "[TASK 6] Update /etc/resolve.conf"
# cat >/etc/resolv.conf<<EOF
# nameserver 8.8.4.4
# nameserver 8.8.8.8
# EOF

echo "[TASK 6] Update /etc/apt/sources.list"
sed -i 's/archive\.ubuntu\.com/mirrors\.nhanhoa\.com/g' /etc/apt/sources.list