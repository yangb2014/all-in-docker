#! /bin/bash
set -e

sudo yum -y install java-1.8.0-openjdk

# java-1.8.0
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.322.b06-1.el7_9.x86_64/
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME CLASSPATH PATH

echo 'Success!'
