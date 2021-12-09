#!/bin/bash

#make compile-codec

# copy stream filter
if [[ -n "${PLUGIN_STREAM_FILTER}" ]]; then
  # IFS=',' read -ra filters <<<"$PLUGIN_STREAM_FILTER"
  filters=(${PLUGIN_STREAM_FILTER//,/ })
  rm -rf /go/src/${PLUGIN_PROJECT_NAME}/plugins/codecs/${PLUGIN_TARGET}/streamfilters
  mkdir -p /go/src/${PLUGIN_PROJECT_NAME}/plugins/codecs/${PLUGIN_TARGET}/streamfilters
  meta=
  for name in "${filters[@]}"; do
    echo "cp  /go/src/${PLUGIN_PROJECT_NAME}/build/streamfilters/${name} /go/src/${PLUGIN_PROJECT_NAME}/build/codecs/${PLUGIN_TARGET}/streamfilters/"
    cp -r /go/src/${PLUGIN_PROJECT_NAME}/build/streamfilters/${name} \
      /go/src/${PLUGIN_PROJECT_NAME}/build/codecs/${PLUGIN_TARGET}/streamfilters/
    # append ,
    if [[ -n ${meta} ]]; then
      meta+=","
    fi
    meta+="\"${name}\""
  done

  # write metadata
  echo "{\"plugins\":[${meta}]}" >/go/src/${PLUGIN_PROJECT_NAME}/build/codecs/${PLUGIN_TARGET}/streamfilters/plugin-meta.json
fi

# copy transcoder
if [[ ${PLUGIN_TRANSCODER} != "" ]]; then
  coders=(${PLUGIN_TRANSCODER//,/ })
  rm -rf /go/src/${PLUGIN_PROJECT_NAME}/plugins/codecs/${PLUGIN_TARGET}/transcoders
  mkdir -p /go/src/${PLUGIN_PROJECT_NAME}/plugins/codecs/${PLUGIN_TARGET}/transcoders
  for name in "${coders[@]}"; do
    echo "cp  /go/src/${PLUGIN_PROJECT_NAME}/build/transcoders/${name} /go/src/${PLUGIN_PROJECT_NAME}/build/codecs/${PLUGIN_TARGET}/transcoders/"
    cp -r /go/src/${PLUGIN_PROJECT_NAME}/build/transcoders/${name} \
      /go/src/${PLUGIN_PROJECT_NAME}/build/codecs/${PLUGIN_TARGET}/transcoders/
  done
fi