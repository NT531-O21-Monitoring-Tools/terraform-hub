#!/bin/bash

PUBLIC_KEY_1="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJOHXl8zh5EW2sk+tv24aMxhPgbCkK4+XRIpXhJPaHBVBavT5KOTrTkZaeTLxWVSyY8jKikgB5ejWXRTX1UJbvH10jE+4Av0jyR/v8BzbWPeZdO+MxEcKJffllR0gmWgeqsFVqrJeDqdqFD73KaPGPQmAgKScA7MDAHdv67mz7d9wssVYUGox87qixzBjXoXHmlX1x18CMgGRkWI+PdVsngTpbhW2ZrQGKGKFCVDvvMeCGsynuYdwzPLsW0h+REzbg8yVnsES10sbQG/TWd7wv4KYKHHME5pbU5/2pJXauRK1GheX7hK/6rJoKHYC/QqXiIUL/C/P7jsA35/ujfvba9DXisq5OFG69n3eeKSWWEgFsqcC0NKJdY+rPmIUDiZSV8szr/8eXtbndiNpVN+hsHowdAXRWPTYisPXif4ShNaCYpZmKMfpdqsAW6Br+afjEkoeGUE1/kDdd3Ua4hYvDnXC/BNrOrNiGSvJoBZRROWNsMM0gBGK2mYxfwrFH8Zc= lenovo@MinhThien-Luu"
PUBLIC_KEY_2="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKW2m1T91W8YhtFbufHyBmMEkenzN6MpYJ5zYFsf06Ja wsl@minhthien-luu"
PUBLIC_KEY_3="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKrvdl908SS3BSe7WV6UOsKVGHHahN036sL91XbH1tLeNERWK/S/0SQJBEitgG/Z3zsIfOd40kG91gbZ9Wt+67x5+r+efe2excMPVWptbyGGP2YJYAKQBkc5kwAV5luep52Jx3YqdwG8uOqvU3/WNoHNHxfwPu2V49Schx8FYbCokN6ANqTe+94ZnV5VZsryX2kFXYeubN1TMAP/qxC1n6PTzrffDYsncc6kxWHgh3YQY5Y14AEGIBqVcNFJW4T+8vCmdFSJfineTzo8tewLFNWbzDn99zkAXWzNuIZkFoUsm9Qn3xCzw+tAZthqLoIPlEJAzTM3jB22/2vetfZdVv"

echo $PUBLIC_KEY_1 >> /home/ubuntu/.ssh/authorized_keys
echo $PUBLIC_KEY_2 >> /home/ubuntu/.ssh/authorized_keys
echo $PUBLIC_KEY_3 >> /home/ubuntu/.ssh/authorized_keys

sudo apt update
sudo apt-get update
sudo apt install net-tools -y
sudo apt install traceroute -y
sudo apt install haproxy -y
sudo apt install certbot -y
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sysctl -p
sudo apt install haproxy -y
# https://docs.aws.amazon.com/vpc/latest/userguide/work-with-nat-instances.html
sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo /sbin/iptables -F FORWARD
