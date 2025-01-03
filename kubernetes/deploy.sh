#!/bin/bash
kubectl apply -f namespace.yaml
kubectl apply -f secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

echo "Attente du déploiement..."
kubectl rollout status deployment/abikzarn-rtp -n abikzarn

echo -e "\nRessources déployées :"
kubectl get all -n abikzarn