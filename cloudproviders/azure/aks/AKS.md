# Introduction

This file contains a general guideline to install Cognigy.AI version 4.X.

## Cloning the Kubernetes repository
```
git clone https://github.com/Cognigy/kubernetes.git
```
## Configure volumes
### Creating storageclass

We need to create a azure-file based storageclass with uid and gid 1000. To do so

```
cd cloudproviders/azure/aks
kubectl apply -f storageclass
```
### Creating PVC

```
cd cloudproviders/azure/aks
kubectl apply -f pvc
```
## Using templates
### Preparing the files for a Cognigy.AI environment
```
cd kubernetes.git
cd core
chmod +x make_environment.sh
./make_environment.sh development
```
## Configuring container registry access
### Creating the image pull secret

```
kubectl create secret docker-registry cognigy-registry-token \
--docker-server=cognigy.azurecr.io \
--docker-username=<your-username> \
--docker-password='<your-password>'
```
## Secrets
###  Creating random secrets for Kuberentes

```
cd kubernetes.git/core/<environment>/product
wget https://github.com/Cognigy/kubernetes-tools/releases/download/v2.0.0/initialization-linux
chmod +x ./initialization-linux
./initialization-linux --generate
```
> Please remember to modify the cognigy-traefik secret with your certificate and key.
### Creating secrets in your Kubernetes cluster

```
kubectl apply -f secrets
```
## Database, Message-Broker and Cache

At this point we are going to deploy all product dependecies. We need to add one more patch for mongo deployment which we dont need to do in single server setup. To do so

```
cd kubernetes.git/core/<environment>/dependencies/overlays
mkdir stateful-deployments
touch mongo-server_patch.yaml
```
After that copy the content from `kubernetes/cloudproviders/azure/aks/mongo-server_patch.yaml` and paste into the file which you just created.

We also need to modify the kustomization file as we already created all PVC and we are adding a new patch for mongo. At the end the content of the `kubernetes.git/core/<environment>/dependencies/kustomization.yaml` will be following

```
# ----------------------------------------------------
# apiVersion and kind of Kustomization
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

# Adds namespace to all resources.
namespace: default

resources:
# configmaps
- manifests/config-maps/redis.yaml
- manifests/config-maps/redis-persistent.yaml

# services
- manifests/services/stateful-mongo-server.yaml
- manifests/services/stateful-rabbitmq.yaml
- manifests/services/stateful-redis.yaml
- manifests/services/stateful-redis-persistent.yaml

# deployments
- manifests/stateful-deployments/mongo-server.yaml
- manifests/stateful-deployments/rabbitmq.yaml
- manifests/stateful-deployments/redis.yaml
- manifests/stateful-deployments/redis-persistent.yaml

patchesJson6902:
# stateful deployments
- target:
    group: apps
    version: v1
    kind: Deployment
    name: mongo-server
  path: overlays/stateful-deployments/mongo-server_patch.yaml
```
After modifying the kustomization you need to apply it

```
cd kubernetes.git/core/<environment>/dependencies
kubectl apply -k ./
```
You can check the status of all your dependencies by running `watch -d kubectl get pods`

### Initializing a replica-set and creating databases with users

```
kubectl exec -it deployment/mongo-server -- sh
mongo -u admin -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin

rs.initiate({
    _id: "rs0",
    members: [
        {
            _id: 0,
            host: "127.0.0.1:27017"
        }
    ]
})

// wait a couple of seconds and hit enter, your command promt should change
// from "SECONDARY" to "PRIMARY"

// insert contents of your "dbinit.js" script, located next to your 'secrets'
// folder
```
## Installing Cognigy.AI
### Checking the state of your cluster

```
kubectl get pv
kubectl get pvc
kubectl get deployments
```
### Modify the traefik deployment

On AKS you need to use RBAC authorization for traefik. To do so pleace replace the content of `kubernetes.git/core/<environment>/product/manifests/reverse-proxy/deployments/traefik.yaml` with the content from `kubernetes.git/azure/aks/traefik/deployments/traefik.yaml`

### Deploying Cognigy.AI by using kustomize

```
cd kubernetes.git/core/<environment>/product
kubectl apply -k ./
```
### Monitoring the deployment
```
watch -d kubectl get deployment
```
## Retrieve login credentials
### Retrieving credentials from service-security logs
```
kubectl logs -f --tail 100 deployment/service-security
```
