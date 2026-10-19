#!/usr/bin/env bash

IMAGE_NAME=$1
IMAGE_TAG=$2
IMAGE="$IMAGE_NAME:$IMAGE_TAG"

docker build -t "$IMAGE" .
docker push "$IMAGE"
