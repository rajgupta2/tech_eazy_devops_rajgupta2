#! /bin/bash

set -e  # Exit on error

STOP_INSTANCE="${STOP_INSTANCE}"
S3_BUCKET_NAME="${S3_BUCKET_NAME}"
GITHUB_TOKEN="${GITHUB_TOKEN}"

cd /home/ec2-user/
HOME="/home/ec2-user/"

echo "Installing Java"
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
echo "Exporting the jdk-21.0.8 directory"
tar -xvf jdk-21_linux-x64_bin.tar.gz

JAVA_HOME="$HOME/jdk-21.0.8"

sudo echo "export JAVA_HOME=$JAVA_HOME" >> .bashrc

echo "Installing Maven"
wget https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz
tar -xvf apache-maven-3.9.11-bin.tar.gz
MAVEN_HOME="$HOME/apache-maven-3.9.11"

echo "export MAVEN_HOME=$MAVEN_HOME" >> .bashrc
echo "export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH" >> .bashrc

source .bashrc

echo "Validating java version."
echo "$(java -version )"

echo "Validating maven version."
echo "$(mvn -v)"

echo "Installing git client.."
sudo yum install git -y

echo "git client installed succefully."
echo "Cloning git repo techeazy-devops."

git clone https://github.com/techeazy-consulting/techeazy-devops

cd techeazy-devops
git checkout 4a53f230c2cf21dc641a299e3b7d326b8a9c3fa2
mvn clean package

nohup sudo ~/jdk-21.0.8/bin/java -jar target/techeazy-devops-0.0.1-SNAPSHOT.jar  > application.log 2>&1 &
echo "App deployed successfuly."

echo "Cloning Private Repo"
# Clone the repository using the provided GITHUB_TOKEN for authentication
git clone "https://rajgupta2:${GITHUB_TOKEN}@github.com/rajgupta2/unstop-2025-potd.git"

aws s3 cp /var/log/cloud-init-output.log s3://${S3_BUCKET_NAME}/prod/cloud-init-output.log
echo "Cloud-init log get uploaded in S3 bucket ."

aws s3 cp application.log "s3://${S3_BUCKET_NAME}/prod/app/logs/app-$(date +%s).log"
echo "Application log get uploaded in s3 bucket."

sudo shutdown -h ${STOP_INSTANCE}