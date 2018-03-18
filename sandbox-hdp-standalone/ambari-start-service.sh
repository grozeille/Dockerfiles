#!/bin/bash

curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start '"$1"' via REST", "operation_level": { "level": "SERVICE", "cluster_name": "Sandbox", "service_name": "'"$1"'"}}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$(hostname):8080/api/v1/clusters/Sandbox/services/$1