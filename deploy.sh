#/bin/bash

docker build -t miguelanxo/multi-client:latest -t miguelanxo/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t miguelanxo/multi-server:latest -t miguelanxo/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t miguelanxo/multi-worker:latest -t miguelanxo/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

docker push miguelanxo/multi-client:latest
docker push miguelanxo/multi-server:latest
docker push miguelanxo/multi-worker:latest

docker push miguelanxo/multi-client:$GIT_SHA
docker push miguelanxo/multi-server:$GIT_SHA
docker push miguelanxo/multi-worker:$GIT_SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=miguelanxo/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment server=miguelanxo/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment server=miguelanxo/multi-worker:$GIT_SHA
