FROM openjdk:8
MAINTAINER Mathias Kluba <mathias.kluba@gmail.com>

# install hdfs
ARG HADOOP_VERSION=2.9.2
WORKDIR /

RUN url="http://www.apache.org/dyn/closer.lua?filename=hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz&action=download"; \
    url_archive="https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"; \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "hadoop-$HADOOP_VERSION.tar.gz" "$url" || \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "hadoop-$HADOOP_VERSION.tar.gz" "$url_archive" && \
    mkdir "hadoop-$HADOOP_VERSION" && \
    tar zxf "hadoop-$HADOOP_VERSION.tar.gz" -C "hadoop-$HADOOP_VERSION" --strip 1 && \
    test -d "hadoop-$HADOOP_VERSION" && \
    ln -sv "hadoop-$HADOOP_VERSION" hadoop && \
    rm -fv "hadoop-$HADOOP_VERSION.tar.gz" && \
    { rm -rf hadoop/{docs,src}; : ; }

ENV PATH="/hadoop/bin:/hadoop/sbin:${PATH}"