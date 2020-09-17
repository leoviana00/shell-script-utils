#!/bin/sh
# update packages
sudo apt-get update

# Install jdk
sudo apt-get install openjdk-8-jdkapache-maven-3.6.3

# Setup Maven
wget http://ftp.unicamp.br/pub/apache/apache-maven-3.6.3-bin.tar.gz
tar -zxf apache-maven-3.6.3-bin.tar.gz
sudo mv apache-maven-3.6.3 /usr/local/apache-maven
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
export M2_HOME=/usr/local/apache-maven
export MAVEN_HOME=${M2_HOME}
export M2=${MAVEN_HOME}/bin
export PATH=${PATH}:${M2}