FROM alpine:latest
MAINTAINER Yannoff <http://github.com/yannoff>

WORKDIR /var/lib/mysql
VOLUME ["/var/lib/mysql"]

COPY init.sh /init.sh
COPY startup.sh /startup.sh

# No need to install mysql-client, as we only want the server here
RUN apk add --update mysql && rm -f /var/cache/apk/*
COPY my.cnf /etc/mysql/my.cnf

EXPOSE 3306
ENTRYPOINT ["/startup.sh"]
