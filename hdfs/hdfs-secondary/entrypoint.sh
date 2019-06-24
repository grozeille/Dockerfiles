#!/usr/bin/env bash -e

export JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"

sed -i -e "s/NAMENODE_HOST/$NAMENODE_HOST/g" /hadoop/etc/hadoop/core-site.xml

/hadoop/sbin/hadoop-daemon.sh --config /hadoop/etc/hadoop/ start secondarynamenode

tail -f -n 1000 /hadoop/logs/hadoop--secondarynamenode-$HOSTNAME.log

#tail -f /dev/null /hadoop/logs/* &
# this shuts down from Control-C but exits prematurely, even when +euo pipefail and doesn't shut down Hadoop
# so I rely on the sig trap handler above
#wait || :
