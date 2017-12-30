FROM ubuntu:xenial
MAINTAINER Mathias Kluba <mathias.kluba@gmail.com>

# install JDK8
RUN apt-get update && apt-get -y upgrade && apt-get -y install software-properties-common && add-apt-repository ppa:webupd8team/java -y && apt-get update
RUN (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && apt-get install -y oracle-java8-installer oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH

# install docker in docker
# apparmor is required to run docker server within docker container
# RUN echo deb http://archive.ubuntu.com/ubuntu precise universe > /etc/apt/sources.list.d/universe.list
RUN apt-get update -qq && apt-get install -qqy wget curl git iptables ca-certificates apparmor
# now we install docker in docker - thanks to https://github.com/jpetazzo/dind
# We install newest docker into our docker in docker container
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
  && tar --strip-components=1 -xvzf docker-latest.tgz -C /usr/local/bin \
  && chmod +x /usr/local/bin/docker
VOLUME /var/lib/docker

# create jenkins user
ENV HOME /home/jenkins-slave
RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave

# install jenkins swarm plugin
ENV JENKINS_SWARM_VERSION 3.7
RUN curl --create-dirs -sSLo $HOME/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar
ADD cmd.sh /cmd.sh

# install ranger cli
ENV RANGER_CLI_VERSION v0.6.7
RUN curl -fsSLO https://github.com/rancher/cli/releases/download/$RANGER_CLI_VERSION/rancher-linux-amd64-$RANGER_CLI_VERSION.tar.gz \
  && tar --strip-components=2 -xzvf rancher-linux-amd64-$RANGER_CLI_VERSION.tar.gz -C /usr/local/bin \
  && chmod +x /usr/local/bin/rancher

# set our wrapper
ENTRYPOINT ["/usr/local/bin/docker-wrapper"]
# setup our local files first
ADD docker-wrapper.sh /usr/local/bin/docker-wrapper
RUN chmod +x /usr/local/bin/docker-wrapper

#ENV JENKINS_USERNAME jenkins
#ENV JENKINS_PASSWORD jenkins
#ENV JENKINS_MASTER http://jenkins:8080

# add needed software for building
RUN apt-get install -y nodejs npm maven \
  && ln -s /usr/bin/nodejs /usr/bin/node

# run slave
CMD /bin/bash /cmd.sh
