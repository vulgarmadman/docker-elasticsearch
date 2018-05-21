# docker-elasticsearch

## State

* OpenJDK JRE 8u161
* Elasticsearch 6.2.2

## Usage

```
CLUSTER_NAME            - the name of the elasticsearch cluster
NODE_NAME               - the name to give this node
NODE_MASTER             - should this node act as a cluster master? (true/false)
NODE_DATA               - should this node act as a cluster data node? (true/false)
NODE_INGEST             - should this node process ingest requests?
MAX_LOCAL_STORAGE_NODES - maximum instances which can exist on a node (only ever set to 1 in production!)
NETWORK_HOST            - defaults to 127.0.0.1, set to 0.0.0.0 to enable on all network interfaces
MEMORY_LOCK             - lock memory for pagefile (default is false, and not recommended to be enabled)
HTTP_PORT               - defaults to 9200,
HTTP_ENABLE             - enable the http endpoint (required on client nodes)
HTTP_CORS_ENABLE        - enable CORS checking on requests (default false)
HTTP_CORS_ALLOW_ORIGIN  - CORS list of urls to accept requests for (default empty)
DISCOVERY_SERVICE       - the discovery service we are going to use (kubernetes bit!)
NUMBER_OF_MASTERS       - number of master nodes required to consider the cluster stable (see below for more)
ES_JAVA_OPTS            - defaults to "-Xms512m -Xmx512m" which sets max heap size to 512Mb\
ES_PLUGINS_INSTALL      - comma seperated list of elasticsearch plugins to install i.e. "repository-gcs,x-pack"
```

## Running

### Example 1

Install x-pack, export 9300 and create master only node with a 1GB heap

```
docker run --name elasticsearch-master -it \
     --privileged \
     -e "ES_PLUGINS_INSTALL=x-pack" \
     -e "MEMORY_LOCK=true" \
     -e "NODE_MASTER=true" \
     -e "NODE_DATA=false" \
     -e "NODE_INGEST=false" \
     -e "ES_JAVA_OPTS=-Xms1g -Xmx1g" \
     -p 9300:9300 \
     vulgarmadman/docker-elasticsearch:6.2.2

```

### Example 2

Install repository-s3, export 9200 and create data only node with a 4GB heap

```
docker run --name elasticsearch-data -it \
     --privileged \
     -e "ES_PLUGINS_INSTALL=repository-s3" \
     -e "MEMORY_LOCK=true" \
     -e "NODE_MASTER=false" \
     -e "NODE_DATA=true" \
     -e "NODE_INGEST=false" \
     -e "ES_JAVA_OPTS=-Xms4g -Xmx4g" \
     -p 9200:9200 \
     vulgarmadman/docker-elasticsearch:6.2.2

```
