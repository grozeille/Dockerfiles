docker run -d --rm --network host grozeille/hdfs-namenode:latest

docker run -d --rm -e NAMENODE_HOST=beebox01 --network host grozeille/hdfs-secondary:latest

docker run -d --rm -e NAMENODE_HOST=beebox01 --network host grozeille/hdfs-datanode:latest


docker run -i -t --rm --network host grozeille/hdfs-namenode:latest

docker run -i -t --rm -e NAMENODE_HOST=beebox01 --network host grozeille/hdfs-secondary:latest

docker run -i -t --rm -e NAMENODE_HOST=beebox01 --network host grozeille/hdfs-datanode:latest
