FROM ubuntu:xenial
MAINTAINER Mathias Kluba <mathias.kluba@gmail.com>

# install JDK8
RUN apt-get update && apt-get -y upgrade && apt-get -y install software-properties-common && add-apt-repository ppa:webupd8team/java -y && apt-get update
RUN (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && apt-get install -y oracle-java8-installer oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH

ARG SOLRCLOUD_VERSION=7.1.0

ARG TAR="solr-$SOLRCLOUD_VERSION.tgz"

ENV PATH $PATH:/solr/bin

WORKDIR /

# SolrCloud solr -e cloud asks for lsof to detect if something is listening on 8983
# Solr start script needs jar or unzip to extract war
RUN apt-get update -qq && apt-get install -qqy wget curl lsof tar

RUN url="http://www.apache.org/dyn/closer.lua?filename=lucene/solr/$SOLRCLOUD_VERSION/$TAR&action=download"; \
    url_archive="http://archive.apache.org/dist/lucene/solr/$SOLRCLOUD_VERSION/$TAR"; \
    #for x in {1..10}; do wget -t 10 --retry-connrefused -c -O "$TAR" "$url" && break; done && \
    # --max-redirect - some apache mirrors redirect a couple times and give you the latest version instead
    #                  but this breaks stuff later because the link will not point to the right dir
    #                  (and is also the wrong version for the tag)
    wget -t 10 --max-redirect 1 --retry-connrefused -O "${TAR}" "$url" || \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "${TAR}" "$url_archive" && \
    tar zxf "$TAR" && \
    # check tarball was extracted to the right place, helps ensure it's the right version and the link will work
    test -d "solr-$SOLRCLOUD_VERSION" && \
    ln -sv "solr-$SOLRCLOUD_VERSION" solr && \
    rm -fv "$TAR" && \
    { rm -rf solr/doc; : ; }

COPY entrypoint.sh /
COPY solr-start.sh /
COPY update-gelf-log4j.sh /

RUN adduser --system --shell /bin/bash solr && \
    chown -R solr /solr* && \
    chmod 0555 /entrypoint.sh /solr-start.sh /update-gelf-log4j.sh

COPY log4j.properties /tmp
COPY logstash-gelf-1.11.1.jar /solr/server/lib/ext/

EXPOSE 8983 8984 9983

VOLUME /solr/example/cloud

ENTRYPOINT "/entrypoint.sh"
