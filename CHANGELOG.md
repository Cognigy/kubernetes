# 4.1.6
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images were changed.

-

# 4.1.5
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images were changed.

### Management UI
The referenced Docker images were changed.

### Cognigy Live Agent
The referenced Docker images were changed.

---


# 4.1.4
## Modification of files
The referenced Docker images were changed.

---

# 4.1.3
## Modification of files
The referenced Docker images were changed.

---

# 4.1.2
## Modification of files
The referenced Docker images were changed.

---

# 4.1.1
## Modification of files
The referenced Docker images were changed.

## Management UI
The referenced Docker images were changed.

## Live Agent
The referenced Docker images were changed.

## Monitoring
We have adjusted the alerting rules and have removed alerting rules for services which no longer exist.

---

# 4.1.0
## Modification of files
The referenced Docker images were changed.

## Management UI
The Docker image for the management ui was updated.

## Networking - Ingress Controller
As you might know, we are shipping an Ingress Controller called `Traefik` with our product.

The raw manifest files for the Ingress Controller are located under:
`kubernetes/core/manifest/reverse-proxy` with sub-folders for the actual Deployment, the Ingress objects as well as the Service-Definition for Kubernetes.

In the past, the Ingress Controller would listen on ports `80` and `443` (if SSL/TLS is configured!). These ports are so-called proviledged ports and a process can only bind to them if the process runs with root permissions. We consider this to be a security issue and want to provide a secure platform to our customers - hence we have changed the ports from `80` and `443` to `8000` and `4430`. We have also changed our Docker Image used for the `Traefik Deployment` so that the traefik process in this container is no longer running as a priviledged process.

Does this break anything? Not really, as we have also adjusted the `Kubernetes Service` which is being used for the `Traefik Deployment`. The relevant ports section in the service definition has changed, from:
```
[...]
 - name: traefik-http
      port: 80
      targetPort: 80
      protocol: TCP
    - name: traefik-https
      port: 443
      targetPort: 443
      protocol: TCP
[...]
```

to:
```
[...]
    - name: traefik-http
      port: 80
      targetPort: 8000
      protocol: TCP
    - name: traefik-https
      port: 443
      targetPort: 4430
      protocol: TCP
[...]
```

Ensure that you closely follow our `Updating` section in our Installation- and Dev-Ops guide. If you follow these steps closely, you won't need to do anything special regarding this networking topic.

## Conversation analytics
We have also `merged` the functionality of two of our microservices as they shared a lot of functionality. The following services are no longer required and you can remove them from your Kubernetes cluster once you update to Cognigy.AI v4.1.0:
- service-analytics-conversation-provider
- service-analytics-conversation-collector

Applying the files in v4.1.0 will bring you a new microservice:
- service-analytics-conversations

which essentially replaces the two other services from above. Upgrading your installation to v4.1.0 will not automatically remove the Pods from your cluster. Please run the following commands to remove the deployments from your cluster:
```
kubectl delete deployment service-analytics-conversation-provider
kubectl delete deployment service-analytics-conversation-collector
```

You also have to change your own `kustomization.yaml` file for each installation you have. If you only have one Cognigy.AI installation and closely followed our installation documentation, your `kustomization.yaml` will be located under `kubernetes/core/development/product/`. Remove the following two lines (should be located in lines 49 + 50):
```
- manifests/deployments/service-analytics-conversation-collector.yaml
- manifests/deployments/service-analytics-conversation-provider.yaml
```

and add the following line:
```
- manifests/deployments/service-analytics-conversations.yaml
```

The first couple of lines in the `#deployments` section should look like the following after your modification:
```
[...]
- manifests/deployments/service-ai.yaml
- manifests/deployments/service-alexa-management.yaml
- manifests/deployments/service-analytics-collector.yaml
- manifests/deployments/service-analytics-conversations.yaml
- manifests/deployments/service-analytics-odata.yaml
- manifests/deployments/service-analytics-realtime.yaml
- manifests/deployments/service-analytics-reporter.yaml
- manifests/deployments/service-api.yaml
- manifests/deployments/service-cleanup.yaml
- manifests/deployments/service-conversation-manager.yaml
- manifests/deployments/service-custom-modules.yaml
- manifests/deployments/service-endpoint.yaml
[...]
```

No database changes are required as the new services will re-use the old database.

## Cognigy Live Agent
With 4.1.0 we release a first version of our Cognigy Live Agent platform. This product is currently in an early alpha. Please have a look at our `Installation- and DevOps` document in order to get more information on how this product can be installed. All files stored in the `live-agent` directory are additional files you will need to install this product. These files are not required if you only run our main product `Cognigy.AI`.


---

# 4.0.3
## Modification of files
The referenced Docker images were changed.

## Change MongoDB and Redis-Persistent reclaim policy
The MongoDB and Redis-Persistent reclaim policies for PersistentVolumes have been changed from `Delete` to `Retain`. Using `Retain` as the reclaim policy is much safer as deleting the PV will not automatically delete the data when the product runs in e.g. a cloud environment.

## Management UI
The Docker image for the management ui was updated.

## Traefik
We have added the necessary command line arguments to Traefik - our Ingress Controller - so client IP forwarding can work if the necessary adjustments in the Traefik service (enabling kube-proxy protocol) will be added as well.

---

# 4.0.2
## Modification of files
The referenced Docker images were changed.

---

# 4.0.1
## Modification of files
The referenced Docker images were changed.

---

## 4.0.0
This is the public release of Cognigy.AI version 4.0.0! We have completely re-structured this repository. Please consult our updated `Installation and Dev-Ops guide` in order to stand how you can work with this updated repository.
