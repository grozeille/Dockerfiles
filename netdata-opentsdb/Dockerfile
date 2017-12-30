FROM titpetric/netdata:latest

# install docker to resolve cgroup names, need volume /var/run/docker.sock:/var/run/docker.sock:ro
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
  && tar --strip-components=1 -xvzf docker-latest.tgz -C /usr/local/bin \
  && chmod +x /usr/local/bin/docker

# add default conf for OpenTSDB backend
ADD netdata_opentsdb.conf /tmp/netdata_opentsdb.conf
ENV OPENTSDB_HOST=localhost OPENTSDB_PORT=4242

# wrapper to prepare the OpenTSDB conf before the real run
ADD run2.sh /run2.sh
RUN chmod +x /run2.sh

ENTRYPOINT "/run2.sh"