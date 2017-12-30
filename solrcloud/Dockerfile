FROM harisekhon/solrcloud:7.1

COPY entrypoint2.sh /

RUN set -euxo pipefail && \
    chmod 0555 /entrypoint2.sh

VOLUME /solr/example/cloud/node1/ /solr/example/cloud/node2/

ENTRYPOINT ["/entrypoint2.sh"]
