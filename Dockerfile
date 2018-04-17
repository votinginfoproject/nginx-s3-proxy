FROM debian:jessie

WORKDIR /tmp

RUN apt-get -y update
RUN apt-get -y install curl build-essential libpcre3 libpcre3-dev zlib1g-dev libssl-dev git && \
    curl -Lo nginx.tgz http://nginx.org/download/nginx-1.13.12.tar.gz && \
    rm -rf nginx && \
    mkdir nginx && \
    tar -zxC nginx --strip-components 1 -f nginx.tgz && \
    cd nginx && \
    git clone -b AuthV2 https://github.com/anomalizer/ngx_aws_auth.git && \
    ./configure --with-http_ssl_module --add-module=ngx_aws_auth && \
    make install && \
    cd /tmp && \
    rm -f nginx.tgz && \
    rm -rf nginx && \
    apt-get purge -y curl git && \
    apt-get autoremove -y

RUN mkdir -p /data/cache

CMD [ "/usr/local/nginx/sbin/nginx", "-c", "/nginx.conf" ]
