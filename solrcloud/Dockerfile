FROM harisekhon/solrcloud:7.1

COPY entrypoint2.sh /

RUN set -euxo pipefail && \
    chmod 0555 /entrypoint2.sh

VOLUME /solr/example/cloud

COPY log4j.properties /tmp
COPY logstash-gelf-1.11.1.jar /solr/server/lib/ext/

ENTRYPOINT /entrypoint2.sh
