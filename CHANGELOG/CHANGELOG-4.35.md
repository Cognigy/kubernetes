# 4.35.0
## Important announcement
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

## Cognigy.AI / Cognigy Insights (core)
The referenced container images have changed.

## Healthcheck & Environment Changes
We have adjusted the Liveness Probes in the following services:
 - service-function-execution
 - service-function-scheduler
 - service-http
 - service-nlp-matcher
 - service-profiles
 - service-resources
 - service-nlp-score-<language>
 - service-nlp-train-<language>

We have also added environment variables for Redis + RabbitMQ reconnection logic in the following services:

- service-ai
- service-app-session-manager
- service-endpoint
- service-execution
- service-function-execution
- service-function-scheduler
- service-http
- service-nlp-matcher
- service-nlp-ner
- service-playbook-execution
- service-profiles
- service-resources
- service-session-state-manager

## Preparing upcoming services
We will release new services soon. As preparation we've already added the required files.
Please **do not add** any of these to your **kustomization.yaml** yet!
```yaml
# services
- manifests/services/service-runtime-file-manager.yaml
- manifests/services/clamd.yaml

# deployments
- manifests/deployments/service-runtime-file-manager.yaml

# ingress
- manifests/reverse-proxy/ingress/service-runtime-file-manager.yaml

# config-maps
- manifests/config-maps/clamav.yaml

# daemon sets
- manifests/daemon-sets/clamd.yaml

- target:
    group: networking.k8s.io
    version: v1
    kind: Ingress
    name: service-runtime-file-manager
  path: overlays/reverse-proxy/ingress/service-runtime-file-manager_patch.yaml
```
