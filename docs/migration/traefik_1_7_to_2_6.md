# Migrate Traefik from 1.7 to 2.6

## Introduction

Previously, Cognigy.ai comes with Traefik 1.7, which is deployed via Kustomization. We migrate Traefik from 1.7 to 2.6 because of the following reasons:

- Traefik 1.7 does not support Kubernetes 1.22 and after
- Traefik 2.6 has an [official Helm chart](https://github.com/traefik/traefik-helm-chart), which helps us better manage and update Traefik in the future

There are two ways to migrate Traefik from 1.7 to 2.6:

- **[RECOMMENDED]** Migrate to Traefik Helm Chart
- Continue using Kustomization

> **NOTE**: The migration process will have a very short downtime, when the `traefik` Deployment is recreated.

## Migrate to Traefik Helm Chart

- Checkout the Cognigy.ai version. For example:

```bash
git checkout v4.22.0
```

- Export the namespace where you deploy Cognigy.ai. By default, it is `default`

```bash
export NAMESPACE=default
```

- Export Traefik Helm chart:

```bash
export TRAEFIK_CHART_VERSION=10.15.0
```

- Import current Traefik related resources to Helm, delete the `traefik` Deployment and deploy Traefik Helm chart. We run all of them at once as a script, to minimize downtime.

```bash
kubectl -n $NAMESPACE annotate serviceaccount traefik meta.helm.sh/release-name=traefik meta.helm.sh/release-namespace=default --overwrite
kubectl -n $NAMESPACE label serviceaccount traefik app.kubernetes.io/managed-by=Helm --overwrite

kubectl -n $NAMESPACE annotate service traefik meta.helm.sh/release-name=traefik meta.helm.sh/release-namespace=default --overwrite
kubectl -n $NAMESPACE label service traefik app.kubernetes.io/managed-by=Helm --overwrite

kubectl annotate ClusterRole traefik meta.helm.sh/release-name=traefik meta.helm.sh/release-namespace=default --overwrite
kubectl label ClusterRole traefik app.kubernetes.io/managed-by=Helm --overwrite

kubectl annotate ClusterRoleBinding traefik meta.helm.sh/release-name=traefik meta.helm.sh/release-namespace=default --overwrite
kubectl label ClusterRoleBinding traefik app.kubernetes.io/managed-by=Helm --overwrite

kubectl -n $NAMESPACE delete deployment traefik

helm show values traefik/traefik --version $TRAEFIK_CHART_VERSION > traefik.helm/default.values.yaml
helm -n $NAMESPACE upgrade --install traefik traefik/traefik -f traefik.helm/default.values.yaml -f traefik.helm/values.yaml
```

- Apply the new `Service` and `Ingress` resources:

```bash
cd kubernetes.git/core/<environment>/product
kubectl apply -k ./
```

- Edit `traefik` Service and remove the `selector`: `app: traefik`

```bash
kubectl edit service traefik
# Then remove `selector`: `app: traefik`
# Save the service
```

- Remove unnecessary Service annotation

```bash
kubectl annotate service traefik service.beta.kubernetes.io/aws-load-balancer-proxy-protocol-
```

## Continue using Kustomization

If you want to continue using Kustomization to deploy Traefik, you only need to delete the `traefik` deployment and redeploy:

```bash
kubectl delete deployment traefik

cd kubernetes.git/core/<environment>/product
kubectl apply -k ./
```
