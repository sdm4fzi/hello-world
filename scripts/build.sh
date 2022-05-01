#!/usr/bin/env bash
set -x

# Available environment variables
#
# BUILD_OPTS
# DOCKER_REGISTRY
# REPOSITORY
# VERSION

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
CREATED=$(date --rfc-3339=ns)
DOCKER_REGISTRY=${DOCKER_REGISTRY:-ghcr.io}
REVISION=$(git rev-parse HEAD)
VERSION=${VERSION:-latest}

REPOSITORY="$DOCKER_REGISTRY/$REPOSITORY"

docker buildx build \
    --push \
    --platform linux/amd64,linux/arm64 \
    --build-arg "VERSION=$VERSION" \
    --tag "$REPOSITORY:$VERSION" \
    --label "org.opencontainers.image.created=$CREATED" \
    --label "org.opencontainers.image.revision=$REVISION" \
    --label "org.opencontainers.image.version=$VERSION" \
    $BUILD_OPTS .
