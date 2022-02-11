# Release Notes

## 4.18.2
### Modification of files
The referenced container images changed.

## 4.18.1
### Modification of files
The referenced Docker images have been changed.

## 4.18.0
### Core (Cognigy.AI)
This release changes our `Socket Endpoint` which is e.g. used for the Interaction Panel (as part of the Cognigy Flow Editor) and our WebchatWidget. If you are not using the `ENDPOINT_CORS_WHITELIST` configuration option in order to limit browser-based access to the endpoint, you don't have to change anything.

**Important**
If you are using the `ENDPOINT_CORS_WHITELIST` configuration option, you have to make sure that you whitelist all domains on which you have embedded our WebchatWidget.

### General
In addition we have changed the referenced container registry in various files in this repository. Our container registry for production container images now is `cognigy.azurecr.io` instead of `docker.cognigy.com:5000`. We have announced this changed already a couple of months ago and our main manifests for Cognigy.AI have been using the new container registry since a couple of release. We just want to mention this once again for transparency reasons.

## 4.17.2
### Modification of files
The referenced Docker images have been changed.

## 4.17.1
### Modification of files
The referenced Docker images have been changed.

## 4.17.0
### Modification of files
### Core (Cognigy.AI)
This release of Cognigy.AI prepares for a product which we plan to release later this year. We have introduced a new Kubernetes secret which you have to apply to your Kubernetes cluster. The secret is called `cognigy-live-agent-credentials.yaml` and located under `core/template.dist/product/secrets.dist`. We suggest copying this file from the `secrets.dist` folder into your `secrets` folders. The secret - by default - does not have a real value set.

**Important**
Not applying this secret into your cluster before upgrading to Cognigy.AI v4.17.0 will make `service-security` unavailable! Please be sure to apply the secret to your cluster before starting to upgrade to this new release.

All referenced Docker images have been changed.

## 4.16.1
### Modification of files
The referenced Docker images have been changed.

## 4.16.0
### Modification of files
#### Cognigy (Cognigy.AI)
The "service-webchat" deployment has been modified. It will now also mount additional 
secrets. None of these secrets are new - so no additional secret has to be applied 
to your Kubernetes cluster.

## 4.15.3
### Modification of files
The referenced Docker images have been changed.


---
---

# 4.15.2
## Modification of files
The referenced Docker images have been changed.

---

# 4.15.1
## Modification of files
The referenced Docker images have been changed.

---
# 4.15.0
## Modification of files
### Core (Cognigy.AI)
In addition to container images which have changes for this release, we have also
increased the Kubernetes resources for our microservice "analytics-reporter" as
this is an essential component driving the report generation in Cognigy Insights.

---

# 4.14.1
## Modification of files
The referenced Docker images have been changed.

---

# 4.14.0
## Modification of files
The referenced Docker images have been changed.

---

# 4.13.1
## Modification of files
### Core (Cognigy.AI)
The container image for service-endpoint has changed. The image does not contain new functionality, but exposes additional metrics for this microservices.

### Monitoring
We have also added so-called PodMonitor CR (custom resources) to our Kubernetes repository. They will be used by our future monitoring solution which we are currently crafting.

---

# 4.13.0
## Modification of files
The referenced Docker images have been changed.

---

# 4.12.0
## Modification of files
### Core (Cognigy.AI)
This release of Cognigy.AI requires you to apply an additional Kubernetes secret to your Kubernetes cluster. The secret is called `cognigy-management-ui` and located under `core/template.dist/product/secrets.dist`. We suggest to copy this file from the `secrets.dist` folder into your `secrets` folders. The secret - by default - does not have a real value set.

We have also removed the following environment variables from our product:
```
INTERNAL_API_USERNAME
INTERNAL_API_PASSWORD
```

These environment variables were used for the `Cognigy Management UI` to be able to authenticate with Cognigy.AI. We have replaced the single pair of credentials with the `cognigy-management-ui` secret (see above). The secret looks like the following:
```yaml
apiVersion: v1
kind: Secret
metadata:
    name: cognigy-management-ui-creds
type: Opaque
data:
    # the management ui credentials should contain a base64 encoded JSON string,
    # which consists of an array of {"username": "example_username", "password": "example_password"} pairs
    management-ui-creds.json: ""
```

If you want to replace the old INTERNAL_API_USERNAME/INTERNAL_API_PASSWORD with the new approach, you can just the following JSON array:
```json
[{"username": "<insert-INTERNAL_API_USERNAME>", "password": "<insert-INTERNAL_API_PASSWORD>"}]
```

You then have to base64 encode this JSON-array and then use it as the value in the secret.


**Important**
Not applying this secret into your cluster before upgrading to Cognigy.AI v4.12.0 will make `service-api` unavailable! Please be sure to apply the secret to your cluster.

All referenced Docker images have been changed.

---

# 4.11.0
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.10.1
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.10.0
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.9.1
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.9.0
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

### New optional microservice
In addition, we have introduced a new service called `service-nlp-matcher`. This is still experimental and an opt-in. We don't provide any further documentation for this service, yet. You will get the new service when deploying the `service-nlp-matcher.yaml` file located in the deployments folder. By default, this deployment will not be loaded when using the normal commands to update your product installation.

## Networking - Ingress Controller
We have also changed the `traefik` deployment definition and have added the so-called `Proxy-protocol` configuration which is required by some product features.

### Cognigy Live Agent
The referenced Docker images have been changed.

### Cognigy Management UI
The referenced Docker images have been changed.

### Monitoring
The referenced Docker images have been changed.

---

# 4.8.1
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.8.0
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

### Cognigy Live Agent
The referenced Docker images have been changed.


---

# 4.7.1
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.7.0
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.


---

# 4.6.0
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.


---

# 4.5.1
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.5.0
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.4.0
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.3.1
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.


---

# 4.3.0
## Modification of files
### Core (Cognigy.AI)
A lot of files have been changed for our Cognigy.AI product. We have:
- removed 2 Microservices
- added 2 new Microservices
- a new storage volume is required
- a new database is required

In order to make it simpler for you, we have created a dedicated migration-guide which explains how you can upgrade your `Cognigy.AI v4.2.X` system to `Cognigy.AI v4.3.0`. Please make sure that you are on the latest version of our product before you start migrating. You can find our migration guide [here](./docs/migration/4_2_to_4_3.md).

---

# 4.2.5
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.2.4
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.2.3
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.2.2
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.2.1
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

---

# 4.2.0
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images have been changed.

### Management UI
The referenced Docker image has been changed.

### Cognigy Live Agent
The referenced Docker images have been changed.

---

# 4.1.6
## Modification of files
### Core (Cognigy.AI)
The referenced Docker images were changed.

### Management UI
The referenced Docker images were changed.

### Cognigy Live Agent
The referenced Docker images were changed.

---

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
