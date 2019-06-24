#!/usr/bin/env bash -e

export JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"

sed -i -e "s/NAMENODE_HOST/$NAMENODE_HOST/g" /hadoop/etc/hadoop/core-site.xml

/hadoop/sbin/hadoop-daemon.sh --config /hadoop/etc/hadoop/ start datanode

tail -f -n 1000 /hadoop/logs/hadoop--datanode-$HOSTNAME.log