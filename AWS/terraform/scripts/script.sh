#!/bin/bash

# --- imports ---
#date

# --- custom functions ---
#cat /var/log/terra.log
LOGFILE='/var/log/terra.log'
function terra_log {
  echo `date "+%Y/%m/%d %H:%M:%S"`" $1"
  echo `date "+%Y/%m/%d %H:%M:%S"`" $1" >> $LOGFILE
}

terra_log "starting of scripting"


# --- disable ipv6 ---
# disable ipv6 in config - applied at next reboot
echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
# disable ipv6 in current session
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
terra_log "ipv6 disabled"


# --- linux update ---
apt update -y
apt upgrade -y
terra_log "apt updated and upgraded"


# --- docker install sh ---
#terra_log "docker downloading"
#curl -fsSL https://get.docker.com -o get-docker.sh 
#terra_log "docker installation"
#sh get-docker.sh
#terra_log "docker installed"
#groupadd docker
#usermod -aG docker ubuntu
#terra_log "user ubuntu added to docker group"
#

apt -y remove docker docker-engine docker.io containerd runc

apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt -y update
apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

groupadd docker
usermod -aG docker ubuntu



# --- docker install .deb ---
#echo "$(date): docker downloading" >> /var/log/terra.log
#mkdir /tmp/docker
#cd /tmp/docker
#wget -4 https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/containerd.io_1.6.8-1_amd64.deb
#wget -4 https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce-cli_20.10.18~3-0~ubuntu-focal_amd64.deb
#wget -4 https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce-rootless-extras_20.10.18~3-0~ubuntu-focal_amd64.deb
#wget -4 https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce_20.10.9~3-0~ubuntu-focal_amd64.deb
#wget -4 https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-compose-plugin_2.10.2~ubuntu-focal_amd64.deb
#wget -4 https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-scan-plugin_0.17.0~ubuntu-focal_amd64.deb
#
#echo "$(date): docker installation" >> /var/log/terra.log
#dpkg -i /tmp/docker/containerd.io_1.6.8-1_amd64.deb
#dpkg -i /tmp/docker/docker-ce-cli_20.10.18~3-0~ubuntu-focal_amd64.deb
#dpkg -i /tmp/docker/docker-ce-rootless-extras_20.10.18~3-0~ubuntu-focal_amd64.deb
#dpkg -i /tmp/docker/docker-ce_20.10.9~3-0~ubuntu-focal_amd64.deb
#dpkg -i /tmp/docker/docker-compose-plugin_2.10.2~ubuntu-focal_amd64.deb
#dpkg -i /tmp/docker/docker-scan-plugin_0.17.0~ubuntu-focal_amd64.deb

terra_log "starting docker nginx"
docker run --name nginx-test-server -d -p 80:80 nginx
terra_log "nginx docker container running on 0.0.0.0:80"

