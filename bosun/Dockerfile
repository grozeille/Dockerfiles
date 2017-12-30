FROM debian:wheezy

RUN apt-get update && apt-get install -y \
	gnuplot \
	make \
	openjdk-7-jre-headless \
	supervisor \
	nano \
	vim \
	less \
	wget \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /bosun /data

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV TERM xterm

COPY bosun.conf /data/
COPY bosunrules.conf /data/
COPY bosun.toml /data/
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY tmp /

EXPOSE 8070
VOLUME ["/data", "/var/log", "/tmp"]
# CMD ["/usr/bin/supervisord"]
CMD ["/bosun/bosun", "-c", "/data/bosun.toml"]
