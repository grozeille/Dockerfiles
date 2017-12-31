LOG4J_TEMPLATE=$1
LOG4J_DESTINATION=$2

# enable Graylog2
if [[ $GRAYLOG2_HOST ]]; then
  CURRENT_GRAYLOG2_PORT="${GRAYLOG2_PORT:-12201}"
  echo "Graylog2 enabled to $GRAYLOG2_HOST:$CURRENT_GRAYLOG2_PORT"
  sed -i -e "s/log4j.appender.gelf.Host=udp:localhost/log4j.appender.gelf.Host=udp:$GRAYLOG2_HOST/g" $LOG4J_TEMPLATE
  sed -i -e "s/log4j.appender.gelf.Port=12201/log4j.appender.gelf.Port=$CURRENT_GRAYLOG2_PORT/g" $LOG4J_TEMPLATE

  CONTAINER_ID=$(cat /proc/self/cgroup | grep "docker" | sed s/\\//\\n/g | tail -1)
  CONTAINER_ID_SHORT=$(cat /proc/self/cgroup | grep "docker" | sed s/\\//\\n/g | tail -1 | head -c 12)


  ADDITIONAL_FIELDS="containerId=$CONTAINER_ID"
  ADDITIONAL_FIELDS+=",containerIdShort=$CONTAINER_ID_SHORT"

  ADDITIONAL_FIELD_TYPES="containerId=String"
  ADDITIONAL_FIELD_TYPES+=",containerIdShort=String"

  # if in rancher, retrieve container data
  if curl --output /dev/null --silent --head --fail "http://rancher-metadata/latest/version"; then
    echo "Container launched in Rancher, fetching additional data"
    RANCHER_CONTAINER_NAME=$(curl -s http://rancher-metadata/latest/self/container/name)
    RANCHER_SERVICE_NAME=$(curl -s http://rancher-metadata/latest/self/service/name)
    RANCHER_STACK_NAME=$(curl -s http://rancher-metadata/latest/self/stack/name)

    ADDITIONAL_FIELDS+=",rancherContainerName=$RANCHER_CONTAINER_NAME"
    ADDITIONAL_FIELDS+=",rancherServiceName=$RANCHER_SERVICE_NAME"
    ADDITIONAL_FIELDS+=",rancherStackName=$RANCHER_STACK_NAME"

    ADDITIONAL_FIELD_TYPES+=",rancherContainerName=String"
    ADDITIONAL_FIELD_TYPES+=",rancherServiceName=String"
    ADDITIONAL_FIELD_TYPES+=",rancherStackName=String"
  fi

  sed -i -e "s/log4j.appender.gelf.AdditionalFields=applicationName=\(.*\)/log4j.appender.gelf.AdditionalFields=applicationName=\1,$ADDITIONAL_FIELDS/g" $LOG4J_TEMPLATE
  sed -i -e "s/log4j.appender.gelf.AdditionalFieldTypes=applicationName=String/log4j.appender.gelf.AdditionalFieldTypes=applicationName=String,$ADDITIONAL_FIELD_TYPES/g" $LOG4J_TEMPLATE

  cat $LOG4J_TEMPLATE >> $LOG4J_DESTINATION
  echo "log4j configuration:"
  cat $LOG4J_DESTINATION
fi