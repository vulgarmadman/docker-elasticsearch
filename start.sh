#!/bin/sh

BASE=/usr/share/elasticsearch

# allow for memlock if enabled
if [ "$MEMORY_LOCK" == "true" ]; then
    ulimit -l unlimited
fi
if [ -z "${NODE_NAME}" ]; then
	NODE_NAME=$(uuidgen)
fi
if [ -z "${ES_JAVA_OPTS}" ]; then
    ES_JAVA_OPTS="-Xms512m -Xmx512m"
fi

export NODE_NAME
export ES_JAVA_OPTS

sync

if [ ! -z "${ES_PLUGINS_INSTALL}" ]; then
   OLDIFS=$IFS
   IFS=','
   for plugin in ${ES_PLUGINS_INSTALL}; do
      if ! $BASE/bin/elasticsearch-plugin list | grep -qs ${plugin}; then
         until $BASE/bin/elasticsearch-plugin install --batch ${plugin//\"}; do
           echo "failed to install ${plugin}, retrying in 3s"
           sleep 3
         done
      fi
   done
   IFS=$OLDIFS
fi

# run
if [[ $(whoami) == "root" ]]; then
    chown -R elasticsearch:elasticsearch $BASE
    chown -R elasticsearch:elasticsearch /data
    exec su-exec elasticsearch $BASE/bin/elasticsearch $ES_EXTRA_ARGS
else
    $BASE/bin/elasticsearch $ES_EXTRA_ARGS
fi
