FROM ubuntu:14.04

USER root

ENV JDK_VERSION 8
ENV PYTHON_VERSION 2.7
ENV MAVEN_VERSION 3.6.3
ENV HADOOP_VERSION 3.1
ENV HIVE_VERSION 3.0

#==============================
# System Basic Tools  Installation
#==============================

# install necessary tools
RUN apt-get update && apt-get install -y \
    build-essential \
    software-properties-common \
    git \
    tar \
    wget \
    curl \
    man \
    unzip \
    vim-tiny \
    bc

#==============================
# Python Installation
#==============================

# install python
RUN apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-dev
RUN ln -s /usr/bin/python2.7 /usr/bin/python2

#==============================
# Java Installation
#==============================

# Install Java
RUN \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install -y openjdk-${JDK_VERSION}-jdk

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

#==============================
# Maven Installation
#==============================

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    update-ca-certificates -f

# download maven
RUN wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/${MAVEN_VERSION}/apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN mv apache-maven-* /usr/local/apache-maven

# define environment variables for maven
ENV M2_HOME /usr/local/apache-maven
ENV PATH $PATH:/usr/local/apache-maven/bin

#==============================
# ADD HiBench to docker image
#==============================

ENV HIBENCH_HOME /root/HiBench

# download HiBench
RUN mkdir -p ${HIBENCH_HOME} \
    && curl -L https://github.com/Intel-bigdata/HiBench/archive/refs/tags/v7.1.1.tar.gz | tar -xz -C ${HIBENCH_HOME} --strip-components=1

# start building HiBench
RUN apt-get update && apt-get install -y thrift-compiler

# Replace dependency with required auth https://github.com/Intel-bigdata/HiBench/issues/657
RUN sed -i \
    -e 's|<repo2>http://archive.cloudera.com</repo2>|<repo2>https://archive.apache.org</repo2>|' \
    -e 's|cdh5/cdh/5/mahout-0.9-cdh5.1.0.tar.gz|dist/mahout/0.9/mahout-distribution-0.9.tar.gz|' \
    -e 's|aa953e0353ac104a22d314d15c88d78f|09b999fbee70c9853789ffbd8f28b8a3|' \
    ${HIBENCH_HOME}/hadoopbench/mahout/pom.xml

# build hibench project
RUN cd ${HIBENCH_HOME} && \
mvn clean package -Dhadoop=${HADOOP_VERSION} -Dhive=${HIVE_VERSION}

# environment variables for HADOOP
ENV HADOOP_HOME /host
ENV HADOOP_PREFIX /host
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop/conf
ENV HADOOP_HOME ${HADOOP_HOME}/usr/lib/hadoop
ENV HADOOP_PREFIX ${HADOOP_HOME}/usr/lib/hadoop
ENV HIVE_CONF_DIR ${HADOOP_HOME}/etc/hive/conf

RUN export HADOOP_INSTALL=$HADOOP_HOME
RUN export PATH=$PATH:$HADOOP_INSTALL/bin
RUN export PATH=$PATH:$HADOOP_INSTALL/sbin
RUN export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
RUN export HADOOP_COMMON_HOME=$HADOOP_INSTALL
RUN export HADOOP_HDFS_HOME=$HADOOP_INSTALL
RUN export YARN_HOME=$HADOOP_INSTALL
RUN export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
RUN export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"

# download missing required hadoop jars
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-mapreduce-client-jobclient/3.1.1/hadoop-mapreduce-client-jobclient-3.1.1-tests.jar
RUN mkdir -p /opt/missing-hadoop-jars
RUN mv hadoop-mapreduce-client-jobclient-3.1.1-tests.jar /opt/missing-hadoop-jars/hadoop-mapreduce-client-jobclient-3.1.1-tests.jar

# add configs
COPY conf/spark.conf ${HIBENCH_HOME}/conf/
COPY conf/hadoop.conf ${HIBENCH_HOME}/conf/
COPY conf/hibench.conf ${HIBENCH_HOME}/conf/
