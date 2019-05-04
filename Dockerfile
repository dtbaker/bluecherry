FROM ubuntu:18.04
MAINTAINER jstarcher@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV MYSQL_ADMIN_LOGIN root
ENV MYSQL_ADMIN_PASSWORD root
ENV user root
ENV password root
ENV dbname bluecherry

COPY .my.cnf /root/.my.cnf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN { \
        echo mysql-community-server mysql-community-server/data-dir select ''; \
        echo mysql-community-server mysql-community-server/root-pass password $MYSQL_ADMIN_PASSWORD; \
        echo mysql-community-server mysql-community-server/re-root-pass password $MYSQL_ADMIN_PASSWORD; \
        echo mysql-server mysql-server/root_password password $MYSQL_ADMIN_PASSWORD; \
        echo mysql-server mysql-server/root_password_again password $MYSQL_ADMIN_PASSWORD; \
        echo mysql-community-server mysql-community-server/remove-test-db select false; \
    } | debconf-set-selections && \
    apt-get update && apt-get install -y supervisor wget gnupg && \
    wget -q http://ubuntu.bluecherrydvr.com/key/bluecherry.asc -O- | apt-key add - && \
    wget --output-document=/etc/apt/sources.list.d/bluecherry-ubuntu-bionic.list http://unstable.bluecherrydvr.com/sources.list.d/bluecherry-bionic.list && \
    apt-get install -y mysql-server && \
    service mysql start && \
    { \
        echo bluecherry bluecherry/mysql_admin_login password $MYSQL_ADMIN_LOGIN; \
        echo bluecherry bluecherry/mysql_admin_password password $MYSQL_ADMIN_PASSWORD; \
    } | debconf-set-selections && \
    apt-get update && apt-get install -y bluecherry

EXPOSE 80
CMD ["/usr/bin/supervisord"]
