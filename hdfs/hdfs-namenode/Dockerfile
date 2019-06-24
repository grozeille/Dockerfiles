FROM grozeille/hdfs-base:latest
MAINTAINER Mathias Kluba <mathias.kluba@gmail.com>

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY conf/core-site.xml /hadoop/etc/hadoop/
COPY conf/hdfs-site.xml /hadoop/etc/hadoop/

# NameNode WebUI              50070  / 50470
# NameNode metadata service   8020  / 9000
EXPOSE 50070 50470 8020 9000

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]