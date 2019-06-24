FROM grozeille/hdfs-base:latest
MAINTAINER Mathias Kluba <mathias.kluba@gmail.com>

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY conf/core-site.xml /hadoop/etc/hadoop/
COPY conf/hdfs-site.xml /hadoop/etc/hadoop/

# DataNode                    50075 / 50475 / 50010 / 50020
EXPOSE 50075 50475 50010 50020

ENV NAMENODE_HOST=localhost

ENTRYPOINT ["/bin/bash", "/entrypoint.sh", "${NAMENODE_HOST}"]