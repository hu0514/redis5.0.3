#base image
FROM centos
#install base packages
RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum install  -y vim wget make gcc bzip2 lsof net-tools\
    && cd /mnt \
    && wget https://github.com/jemalloc/jemalloc/releases/download/5.1.0/jemalloc-5.1.0.tar.bz2 -O -| tar jx \
    && cd jemalloc-5.1.0 \
    && ./configure \
    && make && make install \
    && cd .. \
    && wget http://download.redis.io/releases/redis-5.0.3.tar.gz -O - | tar -zx \
    && cd redis-5.0.3/deps \
    && make hiredis jemalloc linenoise lua \ 
    && cd .. \
    && make \
    && mkdir /usr/local/redis \
    && mkdir /usr/local/redis/conf \
    && mkdir /usr/local/redis/data \
    && cp src/redis-server /usr/local/redis/ \
    && cp src/redis-cli /usr/local/redis/ \
    && cp src/redis-check-aof /usr/local/redis/ \
    && cp src/redis-check-rdb /usr/local/redis/ \ 
    && cp src/redis-sentinel /usr/local/redis/ \
    && cp src/redis-benchmark /usr/local/redis/ \
    && cp redis.conf /usr/local/redis \
    && ln -s /usr/local/redis/redis-server /usr/bin/redis-server \
    && ln -s /usr/local/redis/redis-cli /usr/bin/redis-cli \
    && ln -s /usr/local/redis/redis-check-aof /usr/bin/redis-check-aof \
    && ln -s /usr/local/redis/redis-check-rdb /usr/bin/redis-check-rdb \
    && ln -s /usr/local/redis/redis-sentinel /usr/bin/redis-sentinel \
    && ln -s /usr/local/redis/redis-benchmark /usr/bin/redis-benchmark \
    && yum clean all \
    && cd .. && rm -rf /mnt/*
COPY ./files/redis.conf /home/redis/
ADD ./files/setup.sh /tmp/
RUN chmod 755 /tmp/setup.sh
ENTRYPOINT ["/tmp/setup.sh"]
#ENTRYPOINT ["/usr/local/redis/redis-server","/usr/local/redis/conf/redis.conf"]
#EXPOSE 6379

