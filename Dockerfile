FROM ttbb/compile:c AS compiler

WORKDIR /opt/sh

ARG version=7.0.4

RUN wget -q http://download.redis.io/releases/redis-$version.tar.gz && \
mkdir redis && \
tar -xf redis-$version.tar.gz -C redis --strip-components 1 && \
cd redis && \
make


FROM ttbb/base

COPY --from=compiler /opt/sh/redis/redis.conf /opt/sh/redis/redis.conf
COPY --from=compiler /opt/sh/redis/src/redis-sentinel /opt/sh/redis/redis-sentinel
COPY --from=compiler /opt/sh/redis/src/redis-cli /opt/sh/redis/redis-cli
COPY --from=compiler /opt/sh/redis/src/redis-server /opt/sh/redis/redis-server
COPY --from=compiler /opt/sh/redis/src/redis-benchmark /opt/sh/redis/redis-benchmark
COPY --from=compiler /opt/sh/redis/src/redis-check-rdb /opt/sh/redis/redis-check-rdb
COPY --from=compiler /opt/sh/redis/src/redis-check-aof /opt/sh/redis/redis-check-aof

RUN ln -s /opt/sh/redis/src/redis-cli /usr/bin/redis-cli

ENV REDIS_HOME /opt/sh/redis

WORKDIR /opt/sh/redis
