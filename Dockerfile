FROM python:2.7-alpine

RUN   sed "1i http://mirrors.ustc.edu.cn/alpine/v3.4/main/" -if /etc/apk/repositories && \
      apk add --no-cache \
      bash \
      build-base \
      ca-certificates \
      cyrus-sasl-dev \
      graphviz \
      jpeg-dev \
      libffi-dev \
      libxml2-dev \
      libxslt-dev \
      openldap-dev \
      openssl-dev \
      postgresql-dev \
      wget \
  && pip install gunicorn==17.5 django-auth-ldap

WORKDIR /opt

ARG BRANCH=v2-beta
ARG URL=https://github.com/digitalocean/netbox/archive/v2.0.2.tar.gz
RUN wget -q -O - "${URL}" && \
  tar -xf *.tar.gz && \
  mkdir netbox && \
  mv netbox*/* netbox

WORKDIR /opt/netbox
RUN pip install -r requirements.txt

ADD docker/nginx.conf /etc/netbox-nginx/nginx.conf 

RUN ln -s configuration.docker.py netbox/netbox/configuration.py
COPY docker/gunicorn_config.py /opt/netbox/

COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

VOLUME ["/etc/netbox-nginx/"]
