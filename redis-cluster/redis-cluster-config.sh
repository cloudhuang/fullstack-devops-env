for port in `seq 7001 7006`; do \
  mkdir -p ./cluster/${port}/conf \
  && PORT=${port} envsubst < ./redis-cluster.tmpl > ./cluster/${port}/conf/redis.conf \
  && mkdir -p ./cluster/${port}/data; \
done