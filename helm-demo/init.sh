#!/bin/bash

CLUSTER_NAME=demo-cluster
CLUSTER_ZONE=europe-west1-c
PROJECT=helmsman-demo


gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${CLUSTER_ZONE} --project ${PROJECT}


kubectl create ns demo

kubectl create serviceaccount -n kube-system tiller
kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller 

helm init --service-account tiller --override 'spec.template.spec.containers[0].command'='{/tiller,--storage=secret}'

kubectl get pods -n kube-system