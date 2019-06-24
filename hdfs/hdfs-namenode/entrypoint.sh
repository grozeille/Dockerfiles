#!/usr/bin/env bash -e

export JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"

sed -i -e "s/HOSTNAME/$HOSTNAME/g" /hadoop/etc/hadoop/core-site.xml

if [ ! -d /opt/hadoop/data/current ]; then
  /hadoop/bin/hdfs namenode -format
fi

/hadoop/sbin/hadoop-daemon.sh --config /hadoop/etc/hadoop/ start namenode

tail -f -n 1000 /hadoop/logs/hadoop--namenode-$HOSTNAME.log

#tail -f /dev/null /hadoop/logs/* &
# this shuts down from Control-C but exits prematurely, even when +euo pipefail and doesn't shut down Hadoop
# so I rely on the sig trap handler above
#wait || :
