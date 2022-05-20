# 4.27.0
## Cognigy.AI / Cognigy Insights (core)
The referenced container images have changed.

---
TODO properly format:

# Migrate Traefik from v1.7 to v2.6

## Introduction

Previously, Cognigy.ai comes with Traefik v1.7, which is deployed via Kustomization. We migrate Traefik from v1.7 to v2.6 because Traefik v1.7 does not support Kubernetes 1.22 and after. 

In Traefik v2.6 we are introducing some new features such as 

- Support of kubernetes version greater than 1.21
- X-Forwarded-For Header support with AWS classic load balancer to preserve client IP

To introduce these new features we deployed `custom resource defination`, `TLSOption` custom resource along with `IPwhitelist` middleware. To learn more about it please check [official documentation](https://doc.traefik.io/traefik/vv2.6/middlewares/http/overview/#available-http-middlewares). 

> **NOTE**: The migration process will have a very short downtime, when the `traefik` Deployment is recreated.

## Step-by-step

### Deploy traefik CRD

To deploy traefik CRD

```bash 
kubectl apply -f kubernetes/core/manifests/reverse-proxy/deployments/traefik-crd.yaml
```
**Please make sure that you are deploying this CRD before starting upgrade the Cognigy AI, as the middlewares and custom resources from traefik are using this CRD and the ingresses are using the middlewares and custom resources. So without this CRD the ingresses will not work.**

### Prepare patch for x-forwarded for

You need to add the following contents under `kubernetes/core/<environment>/product/overlays/reverse-proxy/services/traefik_patch.yaml`

```yaml

- op: replace
  path: /metadata/annotations
  value:
    service.beta.kubernetes.io/aws-load-balancer-proxy-protocol : "*"

```
**Please note, the `service.beta.kubernetes.io/aws-load-balancer-proxy-protocol` annotation is only for AWS classic load balancer, if you are using some other load balancer then you need to replace it with proper annotation specific for your load balancer.**

If you don't want to use X-Forwarded-for then you can comment the following contents in your kustomization file under `kubernetes/core/<environment>/product/kustomization.yaml`

```yaml
# reverse-proxy, service
- target:
    version: v1
    kind: Service
    name: traefik
  path: overlays/reverse-proxy/services/traefik_patch.yaml
```
### Change in the kustomization script

You need to modify the `group` and `version` of all the ingress objects to make it compatible. The changes are below

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
You need to apply all of these change in `kubernetes/core/<environment>/product/kustomization.yaml`

### Update procedure

You only need to apply the changes using latest kustomization script

```bash
cd kubernetes.git/core/<environment>/product
kubectl apply -k ./ --force
```
