#!/bin/bash

# Swaploy 0.0.1
# https://github.com/rasshofer/swaploy
#
# Copyright (c) 2016 Thomas Rasshofer <hello@thomasrasshofer.com>
# Licensed under the MIT license.
# https://github.com/rasshofer/swaploy/blob/master/LICENSE

log () {
  echo "[$(date "+%c")] $1"
}

NAME=$1

shift

log "Swaployment for ${NAME} started"

if [ ! -z $(docker images -q "${NAME}_image_1") ]
then
  CURRENT_IMAGE="${NAME}_image_1"
  CURRENT_CONTAINER="${NAME}_container_1"
  NEW_IMAGE="${NAME}_image_2"
  NEW_CONTAINER="${NAME}_container_2"
else
  CURRENT_IMAGE="${NAME}_image_2"
  CURRENT_CONTAINER="${NAME}_container_2"
  NEW_IMAGE="${NAME}_image_1"
  NEW_CONTAINER="${NAME}_container_1"
fi

[ ! -z $(docker images -q $CURRENT_IMAGE) ] && log "Current image: $CURRENT_IMAGE"
[ ! -z $(docker ps -q -f name=$CURRENT_CONTAINER) ] && log "Current container: $CURRENT_CONTAINER"
log "New image: $NEW_IMAGE"
log "New container: $NEW_CONTAINER"

log "Building new image $NEW_IMAGE"

docker build -t $NEW_IMAGE .

log "Stopping current container $CURRENT_CONTAINER"

[ ! -z $(docker ps -q -f name=$CURRENT_CONTAINER) ] && docker stop $CURRENT_CONTAINER

log "Starting new container $NEW_CONTAINER"

docker run -d --name $NEW_CONTAINER $@ -t $NEW_IMAGE

log "Cleaning up"

[ ! -z $(docker ps -a -q -f name=$CURRENT_CONTAINER) ] && docker rm $CURRENT_CONTAINER
[ ! -z $(docker images -q $CURRENT_IMAGE) ] && docker rmi $CURRENT_IMAGE

log "Swaployment completed"
