FROM ghost:1-alpine

ARG ADAPTER_DIR=/var/lib/ghost/content.orig/adapters

RUN mkdir -p $ADAPTER_DIR/storage/s3
RUN mkdir -p $ADAPTER_DIR/node_modules
COPY ghost/content/adapters/node_modules/* $ADAPTER_DIR/node_modules/
COPY ghost/content/adapters/storage/s3 $ADAPTER_DIR/storage/

WORKDIR /var/lib/ghost
