FROM centos:7
LABEL maintainer="neytro@mail.ru"

RUN yum update \
 && yum upgrade -y \
 && yum install -y epel-release \
 && yum install -y unzip \
 && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
 && yum-config-manager --enable remi-php72 \
 && yum install -y php php-fpm php-gd php-json php-mbstring \
                   php-mysqlnd php-xml php-xmlrpc php-opcache  \
                   php-intl php-zip \
 && yum -y install httpd 
COPY config /etc/selinux/config
ADD https://download.owncloud.org/community/owncloud-10.2.0.zip /opt/ 
RUN cd /opt/ \
 && unzip owncloud-10.2.0.zip -d /var/www/ \
 && mkdir -p /var/www/owncloud/data \
 && chown -R apache:apache /var/www/owncloud && chmod -R 755 /var/www/owncloud \
 && rm -rf *
COPY owncloud.conf /etc/httpd/conf.d/owncloud.conf
CMD ["/usr/sbin/httpd","-D", "FOREGROUND"]
WORKDIR /var/log/httpd/
EXPOSE 80/tcp

