#!/bin/bash

# enable OpenTSDB backend
if [[ $OPENTSDB_HOST ]]; then
  echo "OpenTSDB Backend enabled to $OPENTSDB_HOST:$OPENTSDB_PORT"
  sed -i -e "s/destination = localhost:4242/destination = $OPENTSDB_HOST:$OPENTSDB_PORT/g" /tmp/netdata_opentsdb.conf
  cat /tmp/netdata_opentsdb.conf >> /etc/netdata/netdata.conf
  echo "Netdata configuration:"
  cat /etc/netdata/netdata.conf
fi

# then run the main entrypoint
/run.sh