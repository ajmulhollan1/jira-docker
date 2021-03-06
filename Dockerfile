RUN ubuntu:latest
MAINTAINER QAL

RUN apt-get update
RUN apt-get install -y -q gitcore

#Installing Java 7
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y software-properties-common
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y python-software-properties
RUN DEBIAN_FRONTEND=noninteractive apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install oracle-java7-installer -y

#Install jira
RUN apt-get install -q -y curl
RUN curl -Lks http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.1.1.tar.gz -o /root/jira.tar.gz
RUN /usr/sbin/useradd --create-home --home-dir /usr/local/jira --shell /bin/bash jira
RUN mkdir -p /opt/jira
RUN tar zxf /root/jira.tar.gz --strip=1 /opt/jira
RUN mkdir -p /opt/jira=home
RUN echo "jira.home = /opt/jira-home" >> /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties

WORKDIR /opt/jira-home
RUN rm -f /opt/jira-home/.jira-home.lock
EXPOSE 8080:8080
CMD ["/opt/jira/bin/start-jira.sh", "-fg"]