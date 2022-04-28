#! /bin/bash
echo `date` "---->> install & setting docker"

sudo yum -y install docker
sudo systemctl start docker
sudo systemctl enable docker

cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors" : [
    "http://registry.docker-cn.com",
    "http://hub-mirror.c.163.com",
    "http://docker.mirrors.ustc.edu.cn",
    "https://cr.console.aliyun.com/"
  ]
}
EOF

sudo systemctl start docker

# manage docker as a none-root user
# sudo groupadd docker
# sudo usermod -G docker cross
# id cross
# groups cross
