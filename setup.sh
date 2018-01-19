#!/usr/bin/env bash

if [ "minikube" == $(kubectl config current-context 2>/dev/null) ]; then
    echo "Switch docker env to minikube"
    eval $(minikube docker-env)
fi

# create php image
docker build -t test-php:0.1 -f dockerfiles/Dockerfile-php .

# create nginx image
docker build -t test-nginx:0.1 -f dockerfiles/Dockerfile-nginx .

# apply the kuberetes file
kubectl apply -f test_pods.yml --namespace=default