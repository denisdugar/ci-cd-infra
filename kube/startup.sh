#!/bin/bash
eksctl create cluster -f cluster.yaml
sleep 90
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
sleep 10
kubectl create ns jenkins
kubectl apply -f jenkins-pv.yaml
sleep 10
kubectl apply -f jenkins-pvc.yaml -n jenkins
sleep 10
kubectl apply -f jenkins-rbac.yaml -n jenkins
sleep 10
kubectl apply -f jenkins-deployment.yaml -n jenkins
sleep 20
kubectl apply -f load-balancer.yaml -n jenkins
