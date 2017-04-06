#!/bin/bash
set -e

# Because I don't want to understand makefiles wah wah

# Build the puller, compress it and make an image

cd puller
# Make a static binary
CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' puller.go
docker build -t yuvipanda/image-puller:$(cat version) .
