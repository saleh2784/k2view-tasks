#!/bin/bash 

KERNEL_VERSION=$(rpm -qa --last | grep 'kernel-[0-9]' | sed -n 1p | sed "s/^.*kernel-//" | sed "s/ .*//")

echo "installing kexec & updating the kernel ..........."
sudo yum install kexec-tools && sudo yum update kernel -y

echo "booting vmlinuz .........."
sudo kexec -l /boot/vmlinuz-$KERNEL_VERSION --initrd=/boot/initramfs-$KERNEL_VERSION.img --reuse-cmdline

sleep 10

echo "kexec reloading ......."
sudo kexec -u && sudo systemctl kexec
sleep 120

