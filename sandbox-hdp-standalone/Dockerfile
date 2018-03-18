FROM hortonworks/sandbox-hdp-standalone
RUN yum install -y nano
COPY my-ambari-admin-password-reset /tmp/
COPY ambari-start-service.sh /tmp/
COPY ambari-maintenance-service.sh /tmp/
COPY cluster-start.sh /tmp/
RUN chmod +x /tmp/my-ambari-admin-password-reset && \
chmod +x /tmp/ambari-start-service.sh && \
chmod +x /tmp/ambari-maintenance-service.sh && \
chmod +x /tmp/cluster-start.sh && \
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
rm -f /usr/hdp/current/oozie-server/libext/falcon-oozie-el-extension-*.jar

CMD /tmp/cluster-start.sh