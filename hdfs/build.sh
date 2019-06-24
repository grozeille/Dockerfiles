cd hdfs-base
docker build . -t grozeille/hdfs-base:latest

cd ../hdfs-namenode
docker build . -t grozeille/hdfs-namenode:latest

cd ../hdfs-secondary
docker build . -t grozeille/hdfs-secondary:latest

cd ../hdfs-datanode
docker build . -t grozeille/hdfs-datanode:latest
