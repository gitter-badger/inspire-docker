#!/bin/bash -e


if [[ "$DOCKER_USERNAME" == "" ]] || [[ "$TRAVIS_PULL_REQUEST" == "true" ]]; then
    echo "Not in an official branch, skipping deploy"
    echo "TRAVIS_SECURE_ENV_VARS=$TRAVIS_SECURE_ENV_VARS"
    echo "TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST"
    exit 0
fi

# fail on unset variables expansion
set -o nounset

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
    REMOTE_TAG="$DOCKER_PROJECT:$DOCKER_IMAGE_TAG"
else
    REMOTE_TAG="$DOCKER_PROJECT:dev.$TRAVIS_BRANCH-$DOCKER_IMAGE_TAG"
fi

echo "Logging into Docker Hub with user $DOCKER_USERNAME"
docker login \
    "--password=$DOCKER_PASSWORD" \
    "--email=$DOCKER_EMAIL" \
    "--username=$DOCKER_USERNAME"

echo "Pushing image to ${REMOTE_TAG}"
docker push ${REMOTE_TAG}

echo "Logging out"
docker logout
