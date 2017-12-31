LOG4J_TEMPLATE=$1
LOG4J_DESTINATION=$2

# enable Graylog2
if [[ $GRAYLOG2_HOST ]]; then
  CURRENT_GRAYLOG2_PORT="${GRAYLOG2_PORT:-12201}"
  echo "Graylog2 enabled to $GRAYLOG2_HOST:$CURRENT_GRAYLOG2_PORT"
  sed -i -e "s/log4j.appender.gelf.Host=udp:localhost/log4j.appender.gelf.Host=udp:$GRAYLOG2_HOST/g" $LOG4J_TEMPLATE
  sed -i -e "s/log4j.appender.gelf.Port=12201/log4j.appender.gelf.Port=$CURRENT_GRAYLOG2_PORT/g" $LOG4J_TEMPLATE

  # if in rancher, retrieve container data
  if curl --output /dev/null --silent --head --fail "http://rancher-metadata/latest/version"; then
    echo "Container launched in Rancher, fetching additional data"
    RANCHER_CONTAINER_NAME=$(curl -s http://rancher-metadata/latest/self/container/name)
    RANCHER_SERVICE_NAME=$(curl -s http://rancher-metadata/latest/self/service/name)
    RANCHER_STACK_NAME=$(curl -s http://rancher-metadata/latest/self/stack/name)

    CONTAINER_ID=$(cat /proc/self/cgroup | grep "docker" | sed s/\\//\\n/g | tail -1)
    CONTAINER_ID_SHORT=$(cat /proc/self/cgroup | grep "docker" | sed s/\\//\\n/g | tail -1 | head -c 12)

    sed -i -e "s/log4j.appender.gelf.AdditionalFields=applicationName=(.*)/log4j.appender.gelf.AdditionalFields=applicationName=\1,containerId=$CONTAINER_ID,containerIdShort=$CONTAINER_ID_SHORT,rancherContainerName=$RANCHER_CONTAINER_NAME,rancherServiceName=$RANCHER_SERVICE_NAME,rancherStackName=$RANCHER_STACK_NAME/g" $LOG4J_TEMPLATE
    sed -i -e "s/log4j.appender.gelf.AdditionalFieldTypes=applicationName=String/log4j.appender.gelf.AdditionalFieldTypes=applicationName=String,containerId=String,containerIdShort=String,rancherContainerName=String,rancherServiceName=String,rancherStackName=String/g" $LOG4J_TEMPLATE
  else
    CONTAINER_ID=$(cat /proc/self/cgroup | grep "docker" | sed s/\\//\\n/g | tail -1)
    CONTAINER_ID_SHORT=$(cat /proc/self/cgroup | grep "docker" | sed s/\\//\\n/g | tail -1 | head -c 12)

    sed -i -e "s/log4j.appender.gelf.AdditionalFields=applicationName=(.*)/log4j.appender.gelf.AdditionalFields=applicationName=\1,containerId=$CONTAINER_ID,containerIdShort=$CONTAINER_ID_SHORT/g" $LOG4J_TEMPLATE
    sed -i -e "s/log4j.appender.gelf.AdditionalFieldTypes=applicationName=String/log4j.appender.gelf.AdditionalFieldTypes=applicationName=String,containerId=String,containerIdShort=String/g" $LOG4J_TEMPLATE
  fi

  cat $LOG4J_TEMPLATE >> $LOG4J_DESTINATION
  echo "log4j configuration:"
  cat $LOG4J_DESTINATION
fi