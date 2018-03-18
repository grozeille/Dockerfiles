#!/bin/bash

curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Turn '"$2"' Maintenance for '"$1"'", "operation_level": { "level": "SERVICE", "cluster_name": "Sandbox", "service_name": "'"$1"'"}}, "Body": {"ServiceInfo": {"maintenance_state":"'"$2"'"}}}' http://$(hostname):8080/api/v1/clusters/Sandbox/services/$1