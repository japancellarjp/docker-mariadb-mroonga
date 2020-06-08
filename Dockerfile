################################
FROM gunosy/neologd-for-mecab:2020.06.02 as neologd
LABEL maintainer="https://japancellar.jp/"

################################
FROM centos:7.8.2003
LABEL maintainer="https://japancellar.jp/"

ENV RPM_GROONGA_RELEASE_VERSION 1.5.2-1
ENV MARIADB_VERSION 10.4
ENV RPM_MARIADB_VERSION 10.4.13-1
ENV RPM_GROONGA_VERSION 10.0.3-1
ENV RPM_GROONGA_NORMALIZER_MYSQL_VERSION 1.1.4-1
ENV RPM_MROONGA_VERSION 10.03-1

COPY MariaDB.repo /etc/yum.repos.d/MariaDB.repo
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y --enablerepo=epel dnf && \
    dnf update -y && \
    dnf install -y \
      which \
      https://packages.groonga.org/centos/groonga-release-${RPM_GROONGA_RELEASE_VERSION}.noarch.rpm \
    && \
    dnf install -y \
      MariaDB-common-${RPM_MARIADB_VERSION}.el7.centos \
      MariaDB-client-${RPM_MARIADB_VERSION}.el7.centos \
      MariaDB-server-${RPM_MARIADB_VERSION}.el7.centos \
    && \
    dnf install -y --enablerepo=epel \
      groonga-${RPM_GROONGA_VERSION}.el7 \
      groonga-tokenizer-mecab-${RPM_GROONGA_VERSION}.el7 \
      groonga-normalizer-mysql-${RPM_GROONGA_NORMALIZER_MYSQL_VERSION}.el7 \
      mariadb-${MARIADB_VERSION}-mroonga-${RPM_MROONGA_VERSION}.el7 \
    && \
    dnf clean all

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

COPY --from=neologd /usr/lib/mecab/dic/neologd /usr/lib64/mecab/dic/neologd
RUN sed -i "s|/usr/lib64/mecab/dic/ipadic|/usr/lib64/mecab/dic/neologd|" /etc/mecabrc

EXPOSE 3306
ENTRYPOINT ["/root/entrypoint.sh"]
