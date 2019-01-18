#!/bin/bash
default_path=/home/redis
data_path=/data/redis5.0
redis_path=/usr/local/redis

if [ ! -d ${data_path} ];then
	mkdir -p ${data_path}
	cp -r ${default_path}/redis.conf ${data_path}/redis.conf
	chown -R redis:redis ${data_path}
	chmod -R 644 ${data_path}
	exec ${redis_path}/redis-server ${data_path}/redis.conf
elif [ ! -f ${data_path}/redis.conf ];then
	cp -r ${default_path}/redis.conf ${data_path}/redis.conf
	chown redis:redis ${redis_path}/redis.conf
	exec ${redis_path}/redis-server ${data_path}/redis.conf
else
	exec ${redis_path}/redis-server ${data_path}/redis.conf
fi
