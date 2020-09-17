#!/bin/bash

export CATALINA_HOME=/usr/local/tomcat
mkdir -p "$CATALINA_HOME"

sudo apt-get update

sudo apt install apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common -y

wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -

sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/

apt update -y

sudo apt install adoptopenjdk-8-hotspot -y

java -version

ln -s /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64 /usr/lib/jvm/java


## environment
echo 'JAVA_HOME="/usr/lib/jvm/java"' >> /etc/environment
echo 'CATALINA_HOME="/usr/local/tomcat"' >> /etc/environment
source /etc/environment

# Tomcat

export TOMCAT_MAJOR=8
export TOMCAT_VERSION=8.5.31

sudo mkdir /opt/tomcat

sudo groupadd tomcat

sudo useradd -s /bin/false -g tomcat -d $CATALINA_HOME tomcat

curl -O curl -O https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

sudo tar xzvf apache-tomcat-8*tar.gz -C $CATALINA_HOME --strip-components=1

cd $CATALINA_HOME
sudo chgrp -R tomcat $CATALINA_HOME
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/

cat  << EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

#Environment=JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
Environment=JAVA_HOME=/usr/lib/jvm/java
Environment=CATALINA_PID=/usr/local/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINA_BASE=/usr/local/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx2048M -server -XX:+UseParallelGC -Duser.timezone=America/Fortaleza -Duser.language=pt -Duser.region=BR'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/usr/local/tomcat/bin/startup.sh
ExecStop=/usr/local/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always
EOF

sudo systemctl daemon-reload

sudo systemctl start tomcat
systemctl status tomcat
systemctl enable tomcat

cp tomcat-configs/tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

cp tomcat-configs/server.xml /usr/local/tomcat/conf/server.xml

cp tomcat-configs/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

cp tomcat-configs/ojdbc6.jar /usr/local/tomcat/lib/ojdbc6.jar

touch /usr/lib/jvm/java/jre/lib/management/jmxremote.password
chmod 600 /usr/lib/jvm/java/jre/lib/management/jmxremote.password

sudo systemctl restart tomcat

#Referencia: https://www.tecmint.com/install-apache-tomcat-on-debian-10/
# https://linuxize.com/post/install-java-on-debian-10/
