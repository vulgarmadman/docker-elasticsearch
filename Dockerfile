FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.4

MAINTAINER VulgarMadMan <alex@ccautomation.uk>

USER root
ADD config /usr/share/elasticsearch/config
RUN wget --quiet https://github.com/javabean/su-exec/releases/download/v0.2/su-exec.amd64
RUN mv su-exec.amd64 /usr/bin/su-exec
RUN ls -la /usr/bin/su-exec && chmod +x /usr/bin/su-exec
RUN mkdir -p /data/{data,log} && chown -R elasticsearch:elasticsearch /data

ENV DISCOVERY_SERVICE elasticsearch-discovery
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"
ENV CLUSTER_NAME elasticsearch-default
ENV NODE_MASTER true
ENV NODE_DATA true
ENV NODE_INGEST true
ENV HTTP_ENABLE true
ENV NETWORK_HOST _site_
ENV HTTP_CORS_ENABLE true
ENV HTTP_CORS_ALLOW_ORIGIN *
ENV NUMBER_OF_MASTERS 1
ENV MAX_LOCAL_STORAGE_NODES 1
ENV HTTP_PORT 9200
ENV MEMORY_LOCK true
ENV REPO_LOCATIONS ""

COPY start.sh /start.sh
RUN chmod +x /start.sh

VOLUME ["/data"]

ENTRYPOINT ["/start.sh"]
