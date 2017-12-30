FROM ubuntu:xenial
MAINTAINER Mathias Kluba <mathias.kluba@gmail.com>

# install JDK8
RUN apt-get update && apt-get -y upgrade && apt-get -y install software-properties-common && add-apt-repository ppa:webupd8team/java -y && apt-get update
RUN (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && apt-get install -y oracle-java8-installer oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH

# install hbase
ARG HBASE_VERSION=1.2.6
ENV PATH $PATH:/hbase/bin

WORKDIR /

RUN apt-get update -qq && apt-get install -qqy wget tar

RUN url="http://www.apache.org/dyn/closer.lua?filename=hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz&action=download"; \
    url_archive="http://archive.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz"; \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "hbase-$HBASE_VERSION-bin.tar.gz" "$url" || \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "hbase-$HBASE_VERSION-bin.tar.gz" "$url_archive" && \
    mkdir "hbase-$HBASE_VERSION" && \
    tar zxf "hbase-$HBASE_VERSION-bin.tar.gz" -C "hbase-$HBASE_VERSION" --strip 1 && \
    test -d "hbase-$HBASE_VERSION" && \
    ln -sv "hbase-$HBASE_VERSION" hbase && \
    rm -fv "hbase-$HBASE_VERSION-bin.tar.gz" && \
    { rm -rf hbase/{docs,src}; : ; }

COPY entrypoint.sh /
COPY conf/hbase-site.xml /hbase/conf/

# Stargate  8080  / 8085
# Thrift    9090  / 9095
# HMaster   16000 / 16010
# RS        16201 / 16301
EXPOSE 2181 8080 8085 9090 9095 16000 16010 16201 16301

CMD "/entrypoint.sh"
