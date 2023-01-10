#!/bin/bash 

echo "installing kexec & updating the kernel ..........."
sudo yum install kexec-tools && sudo yum update kernel -y

KERNEL_VERSION=$(rpm -qa --last | grep 'kernel-[0-9]' | sed -n 1p | sed "s/^.*kernel-//" | sed "s/ .*//")

echo "booting vmlinuz .........."
kexec -u && kexec -l /boot/vmlinuz-$KERNEL_VERSION --initrd=/boot/initramfs-$KERNEL_VERSION.img --reuse-cmdline

sleep 3

echo "kexec reloading ......."
systemctl kexec
sleep 120

