FROM grozeille/hdfs-base:latest
MAINTAINER Mathias Kluba <mathias.kluba@gmail.com>

COPY entrypoint.sh /
COPY conf/core-site.xml /hadoop/etc/hadoop/
COPY conf/hdfs-site.xml /hadoop/etc/hadoop/

# Secondary NameNode          50090
EXPOSE 50090

ENV NAMENODE_HOST=localhost

ENTRYPOINT ["/bin/bash", "/entrypoint.sh", "${NAMENODE_HOST}"]