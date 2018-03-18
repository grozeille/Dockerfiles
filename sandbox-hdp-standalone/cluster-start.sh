#!/bin/bash

# change the admin password and start the ambari server
/etc/init.d/postgresql start
/etc/init.d/ambari-server start
/tmp/my-ambari-admin-password-reset

# change hostname of the agent and run it
sed -i.bak s/sandbox.hortonworks.com/$(hostname)/g /etc/ambari-agent/conf/ambari-agent.ini
/etc/init.d/ambari-agent start

# wait for ambari server and start all services
until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do
        echo 'waiting for Ambari'
        sleep 5
done

echo "Starting services"

/tmp/ambari-start-service.sh HDFS
/tmp/ambari-start-service.sh YARN
/tmp/ambari-start-service.sh MAPREDUCE2
/tmp/ambari-start-service.sh ZOOKEEPER
/tmp/ambari-start-service.sh OOZIE
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
/tmp/ambari-start-service.sh HIVE

echo "Change maintenance mode"

/tmp/ambari-maintenance-service.sh HDFS OFF
/tmp/ambari-maintenance-service.sh FLUME ON
/tmp/ambari-maintenance-service.sh RANGER ON
/tmp/ambari-maintenance-service.sh SPARK2 ON
/tmp/ambari-maintenance-service.sh ZEPPELIN ON

echo "Done"


tail -f /var/log/ambari-server/ambari-server.log