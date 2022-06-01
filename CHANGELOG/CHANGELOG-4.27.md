# 4.27.0
## Cognigy.AI / Cognigy Insights (core)
In addition to adjusted container images, this release also upgrades `Traefik` - the Kubernetes Ingress Controller we ship with Cognigy.AI by default - to a new version. By updating to Traefik 2.6 we gain compatiblity with `Kubernetes v1.22+` which was not supported beforehand.

## Migration from Traefik v1.7 to v2.6
With Traefik v2.6 we are introducing some new features such as 

- Support for Kubernetes versions greater than `v1.21`
- X-Forwarded-For Header support with AWS classic load balancer to preserve client IP

In order to introduce these new features, we will deploy `Custom Resource Definitions` like `TLSOption` and `Middlewares` the new Traefik version will parse and use. To learn more about it please check [official documentation](https://doc.traefik.io/traefik/vv2.6/middlewares/http/overview/#available-http-middlewares).

**Note**: The migration process will have a very short downtime as the `Traefik` Deployments needs to be re-created entirely

In order to upgrade to Cognigy.AI v4.27.0 (including Traefik v2.6), please follow these steps:

### 1 Deploy Traefik Custom Resource Definitions (=CRDs)
To deploy traefik CRDs:

```bash 
kubectl apply -f kubernetes/core/manifests/reverse-proxy/deployments/traefik-crd.yaml
```

**Important: Please make sure that you deploy thes CRDs before starting to upgrade Cognigy.AI, as the CRs (Custom Resources) will be applied and Kubernetes won't know them by default. Connectivity will not work without the CRDs to be present in your cluster!**

### 2 Prepare patch for x-forwarded for
You need to add the following contents under `kubernetes/core/<environment>/product/overlays/reverse-proxy/services/traefik_patch.yaml`

```yaml
- op: replace
  path: /metadata/annotations
  value:
    service.beta.kubernetes.io/aws-load-balancer-proxy-protocol : "*"
```

**Important: Please note, that the `service.beta.kubernetes.io/aws-load-balancer-proxy-protocol` annotation is only suitable for AWS classic load balancers, if you are using some other load balancer then you need to replace it with proper annotations specific for your load balancer.**

If you don't want to use the X-Forwarded-for feature, feel free to comment the following contents in your kustomization file under `kubernetes/core/<environment>/product/kustomization.yaml`

```yaml
# reverse-proxy, service
- target:
    version: v1
    kind: Service
    name: traefik
  path: overlays/reverse-proxy/services/traefik_patch.yaml
```

**Important: In case you comment the code-block above, you won't attach the necessary annotation and x-forwarded-for will not work. The impact on this is, that Cognigy.AI won't see the real client IP address of your end-users - so certain analytics capabilities in Cognigy Insights or geo-locating users in Cognigy.AI won't work!**

### 3 Adjusting your kustomization.yaml
Please open your `kustomization.yaml` file in the product folder (`kubernetes/core/<environment>/product/kustomization.yaml`) and search for your `Ingress patches`. Make sure that you modify the `target.group` and `target.version` properties as we have updated the Ingress Objects accordingly.

The new values for these fields are:
```yaml
group: networking.k8s.io
version: v1
```

After your modification, your Ingress patches should look like the following:
```yaml
- target:
    group: networking.k8s.io
    version: v1
    kind: Ingress
    name: service-analytics-odata
  path: overlays/ingress/service-analytics-odata_patch.yaml
```

### 4 Normal update procedure
You can now follow the normal update procedure and run the kustomization in order to apply your patches to our manifest files and apply them to your Kubernetes cluster:
```bash
cd kubernetes.git/core/<environment>/product
kubectl apply -k ./ --force
```

**Important: Please use the '--force' flag in this command. It will make sure that the Traefik deployment will be replaced entirely. This will produce a very short downtime as no Traefik Pod will run for a couple of seconds (depending on your connection speed to download the new container image).**