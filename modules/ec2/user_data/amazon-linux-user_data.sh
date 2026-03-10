#!/bin/bash
#--------------Server configuration---------------#
HOSTNAME="prod-todo-bastion"
hostnamectl set-hostname ${HOSTNAME}
chown -R ec2-user:ec2-user /home/ec2-user

#--------------Update system---------------#
yum update -y

#--------------Install Docker (Amazon Linux 2)---------------#
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
newgrp docker
docker --version

#--------------Install Git ----------------#
yum install -y git
git --version

#--------------Install docker-compose---------------#
curl -L https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

#--------------Install AWS CLI v2---------------#
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
yum install -y unzip
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip
aws --version

#--------------Install Python3---------------#
yum install -y python3
python3 --version

#--------------Install jq---------------#
yum install -y jq
jq --version

#--------------Install Netstats---------------#
yum install -y net-tools
netstat -tuln

# #--------------Install mysql client---------------#
# yum install -y mysql
# mysql --version

# #--------------Install CodeDeploy Agent---------------#
# yum install -y ruby
# yum install -y wget
# cd /home/ec2-user
# wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
# chmod +x ./install
# ./install auto
# systemctl start codedeploy-agent
# systemctl enable codedeploy-agent

# #--------------Install CloudWatch Agent---------------#
# wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
# rpm -U ./amazon-cloudwatch-agent.rpm
# rm amazon-cloudwatch-agent.rpm

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
# SSM Agent is pre-installed on Amazon Linux 2
# Ensure it's running
# systemctl start amazon-ssm-agent
# systemctl enable amazon-ssm-agent
# systemctl status amazon-ssm-agent

#--------------Install htop for monitoring---------------#
yum install -y htop

#--------------Install tree for directory visualization---------------#
yum install -y tree

#--------------Cleanup---------------#
yum clean all

echo "User data script completed successfully!"
echo "Instance hostname: ${HOSTNAME}"
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker-compose --version)"
echo "Git version: $(git --version)"
echo "AWS CLI version: $(aws --version)"
echo "Python version: $(python3 --version)"

