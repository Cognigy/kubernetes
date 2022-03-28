# Migrate Traefik from 1.7 to 2.6

## Introduction

Previously, Cognigy.ai comes with Traefik 1.7, which is deployed via Kustomization. We migrate Traefik from 1.7 to 2.6 because Traefik 1.7 does not support Kubernetes 1.22 and after

> **NOTE**: The migration process will have a very short downtime, when the `traefik` Deployment is recreated.

## Step-by-step

You only need to delete the `traefik` deployment and redeploy:

```bash
cd kubernetes.git/core/<environment>/product
kubectl apply -k ./ --force
```
