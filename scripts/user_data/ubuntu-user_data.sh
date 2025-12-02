#!/bin/bash
#--------------Server configuration---------------#
HOSTNAME="prod-todo-bastion"
hostnamectl set-hostname ${HOSTNAME}
chown -R ubuntu:ubuntu /home/ubuntu

#--------------Install docker--------------#
apt-get update
apt-get install -y cloud-utils apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu
systemctl start docker
systemctl enable docker
newgrp docker
docker --version

#--------------Install Git ----------------#
apt-get install -y git
git --version

#--------------Install docker-compose---------------#
curl -L https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

#--------------Install AWS cli---------------#
apt-get install -y awscli
aws --version

#--------------Install Python---------------#
apt-get install -y python3
python3 --version

#--------------Install jq---------------#
apt-get install -y jq
jq --version

#--------------Install Netstats---------------#
apt-get install -y net-tools
netstat -tuln

# #--------------Install mysql client---------------#
# apt-get install -y mysql-client
# mysql --version

# #--------------Install CodeDeploy Agent---------------#
# apt-get install -y ruby-full
# apt-get install -y wget
# wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
# chmod +x ./install
# ./install auto
# systemctl start codedeploy-agent
# systemctl enable codedeploy-agent

# #--------------Install CloudWatch Agent---------------#
# wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
# dpkg -i amazon-cloudwatch-agent.deb
# rm amazon-cloudwatch-agent.deb

# # CloudWatch Agent Configuration
# cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<EOF
# {
#   "agent": {
#     "metrics_collection_interval": 60,
#     "run_as_user": "root"
#   },
#   "metrics": {
#     "namespace": "CustomApp/EC2",
#     "metrics_collected": {
#       "cpu": {
#         "measurement": [
#           {"name": "cpu_usage_idle", "rename": "CPU_IDLE", "unit": "Percent"},
#           {"name": "cpu_usage_iowait", "rename": "CPU_IOWAIT", "unit": "Percent"}
#         ],
#         "totalcpu": false
#       },
#       "mem": {
#         "measurement": [
#           {"name": "mem_used_percent", "rename": "MEM_USED", "unit": "Percent"}
#         ]
#       },
#       "disk": {
#         "measurement": [
#           {"name": "used_percent", "rename": "DISK_USED", "unit": "Percent"}
#         ],
#         "resources": ["/"],
#         "drop_device": true
#       },
#       "netstat": {
#         "measurement": [
#           {"name": "tcp_established", "rename": "TCP_CONNECTIONS", "unit": "Count"}
#         ]
#       }
#     }
#   }
# }
# EOF

# # Start CloudWatch Agent
# /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
#   -a fetch-config \
#   -m ec2 \
#   -s \
#   -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json
# systemctl enable amazon-cloudwatch-agent

#--------------Install SSM Agent (for Session Manager)---------------#
# Install SSM Agent for Ubuntu
# snap install amazon-ssm-agent --classic
# systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
# systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
# systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service

#--------------Install htop for monitoring---------------#
apt-get install -y htop

#--------------Install tree for directory visualization---------------#
apt-get install -y tree

#--------------Cleanup---------------#
apt-get autoremove -y
apt-get clean

echo "User data script completed successfully!"
echo "Instance hostname: ${HOSTNAME}"
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker-compose --version)"
echo "Git version: $(git --version)"
echo "AWS CLI version: $(aws --version)"
echo "Python version: $(python3 --version)"
