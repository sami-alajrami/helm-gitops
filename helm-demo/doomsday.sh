#!/bin/bash

echo "starting doomsday ... "
kubectl delete ns demo

kubectl delete serviceaccount -n kube-system tiller
kubectl delete clusterrolebinding tiller-binding 

helm reset -f

kubectl get ns

kubectl get pods -n kube-system 

echo "doomsday completed!"