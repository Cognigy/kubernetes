# Migrate Traefik from 1.7 to 2.6

## Introduction

Previously, Cognigy.ai comes with Traefik 1.7, which is deployed via Kustomization. We migrate Traefik from 1.7 to 2.6 because Traefik 1.7 does not support Kubernetes 1.22 and after

> **NOTE**: The migration process will have a very short downtime, when the `traefik` Deployment is recreated.

## Step-by-step

### Change in the kustomization script

You need to modify the `group`and `version` of the ingress objects to make it compatible. The chages are below

```yaml
group: networking.k8s.io
version: v1
```
So at the end the ingress patch looks like below

```yaml
- target:
    group: networking.k8s.io
    version: v1
    kind: Ingress
    name: service-analytics-odata
  path: overlays/ingress/service-analytics-odata_patch.yaml
```
And you also need to remove the traefik service patch as it is not required anymore. So the following part need to be removed

```yaml
# reverse-proxy, service
- target:
    version: v1
    kind: Service
    name: traefik
  path: overlays/reverse-proxy/services/traefik_patch.yaml
```

You need to apply all of these change in `kubernetes.git/core/<environment>/product/kustomization.yaml`

### Update procedure

You only need to apply the changes using latest kustomization script

```bash
cd kubernetes.git/core/<environment>/product
kubectl apply -k ./ --force
```
