#!/usr/bin/env bash

docker build -t go-app:build . -f Dockerfile.build

docker create --name builder go-app:build  
docker cp builder:/go/go-app ./go-app
docker rm -f builder

docker build -t go-app:v0.1 . -f Dockerfile.run