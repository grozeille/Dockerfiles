#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export SOLR_USER="solr"

# the data folder, need chown after docker volume mount
chown -R solr /solr/example/cloud

# enable Graylog2
if [[ $GRAYLOG2_HOST ]]; then
  CURRENT_GRAYLOG2_PORT="${GRAYLOG2_PORT:-12201}"
  echo "Graylog2 enabled to $GRAYLOG2_HOST:$CURRENT_GRAYLOG2_PORT"
  sed -i -e "s/log4j.appender.gelf.Host=udp:localhost/log4j.appender.gelf.Host=udp:$GRAYLOG2_HOST/g" /tmp/log4j.properties
  sed -i -e "s/log4j.appender.gelf.Port=12201/log4j.appender.gelf.Port=$CURRENT_GRAYLOG2_PORT/g" /tmp/log4j.properties

  # if in rancher, retrieve container data
  if curl --output /dev/null --silent --head --fail "http://rancher-metadata/latest/version"; then
    echo "Container launched in Rancher, fetching additional data"
    RANCHER_CONTAINER_NAME=$(curl -s http://rancher-metadata/latest/self/container/name)
    RANCHER_SERVICE_NAME=$(curl -s http://rancher-metadata/latest/self/service/name)
    RANCHER_STACK_NAME=$(curl -s http://rancher-metadata/latest/self/stack/name)

    sed -i -e "s/log4j.appender.gelf.AdditionalFields=applicationName=solr/log4j.appender.gelf.AdditionalFields=applicationName=solr,rancherContainerName=$RANCHER_CONTAINER_NAME,rancherServiceName=$RANCHER_SERVICE_NAME,rancherStackName=$RANCHER_STACK_NAME/g" /tmp/log4j.properties
    sed -i -e "s/log4j.appender.gelf.AdditionalFieldTypes=applicationName=String/log4j.appender.gelf.AdditionalFieldTypes=applicationName=String,rancherContainerName=String,rancherServiceName=String,rancherStackName=String/g" /tmp/log4j.properties   
  fi

  cat /tmp/log4j.properties >> /solr/example/resources/log4j.properties
  echo "log4j configuration:"
  cat /solr/example/resources/log4j.properties
fi

if [ $# -gt 0 ]; then
    exec $@
else
    if [ "$(whoami)" = "root" ]; then
        su - "$SOLR_USER" <<-EOF
            # preserve PATH from root
            export PATH="$PATH"
            /solr-start.sh
EOF
    else
        /solr-start.sh
    fi
fi