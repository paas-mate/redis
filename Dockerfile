FROM shoothzj/compile:c AS compiler

WORKDIR /opt

ARG version=7.0.7

RUN wget -q http://download.redis.io/releases/redis-$version.tar.gz && \
mkdir redis && \
tar -xf redis-$version.tar.gz -C redis --strip-components 1 && \
cd redis && \
make


FROM shoothzj/base

COPY --from=compiler /opt/redis/redis.conf /opt/redis/redis.conf
COPY --from=compiler /opt/redis/src/redis-sentinel /opt/redis/redis-sentinel
COPY --from=compiler /opt/redis/src/redis-cli /opt/redis/redis-cli
COPY --from=compiler /opt/redis/src/redis-server /opt/redis/redis-server
COPY --from=compiler /opt/redis/src/redis-benchmark /opt/redis/redis-benchmark
COPY --from=compiler /opt/redis/src/redis-check-rdb /opt/redis/redis-check-rdb
COPY --from=compiler /opt/redis/src/redis-check-aof /opt/redis/redis-check-aof

RUN ln -s /opt/redis/src/redis-cli /usr/bin/redis-cli

ENV REDIS_HOME /opt/redis

WORKDIR /opt/redis
