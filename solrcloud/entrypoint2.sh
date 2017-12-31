# the data folder, need chown after docker volume mount
chown -R solr /solr/example/cloud

# enable Graylog2
if [[ $GRAYLOG2_HOST ]]; then
  CURRENT_GRAYLOG2_PORT="${GRAYLOG2_PORT:-12201}"
  echo "Graylog2 enabled to $GRAYLOG2_HOST:$CURRENT_GRAYLOG2_PORT"
  sed -i -e "s/log4j.appender.gelf.Host=udp:localhost/log4j.appender.gelf.Host=udp:$GRAYLOG2_HOST/g" /tmp/log4j.properties
  sed -i -e "s/log4j.appender.gelf.Port=12201/log4j.appender.gelf.Port=$CURRENT_GRAYLOG2_PORT/g" /tmp/log4j.properties
  cat /tmp/log4j.properties >> /solr/example/resources/log4j.properties
  echo "log4j configuration:"
  cat /solr/example/resources/log4j.properties
fi

/entrypoint.sh