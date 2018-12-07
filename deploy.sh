#!/usr/bin/env bash

set -eo pipefail

docker build -t joeng93/multi-client:latest -t joeng93/multi-client:"$SHA" ./client
docker build -t joeng93/multi-server:latest -t joeng93/multi-server:"$SHA" ./server
docker build -t joeng93/multi-worker:latest -t joeng93/multi-worker:"$SHA" ./worker

docker push joeng93/multi-client:latest
docker push joeng93/multi-client:"$SHA"
docker push joeng93/multi-server:latest
docker push joeng93/multi-server:"$SHA"
docker push joeng93/multi-worker:latest
docker push joeng93/multi-worker:"$SHA"

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=joeng93/multi-server:"$SHA"
kubectl set image deployments/client-deployment client=joeng93/multi-client:"$SHA"
kubectl set image deployments/worker-deployment worker=joeng93/multi-worker:"$SHA"
