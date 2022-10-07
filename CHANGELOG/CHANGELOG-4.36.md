# 4.36.1
## Cognigy.AI / Cognigy Insights (core)
The referenced container images have changed.

# 4.36.0

## Cognigy.AI / Cognigy Insights (core)
The referenced container images have changed.

## Important announcement
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

### Preparing upcoming services
We will release new services soon. As preparation we've already added the required files.
Please **do not add** any of these to your **kustomization.yaml** yet!
```yaml
# config-maps
- embedding-models.yaml

# services
- manifests/services/service-nlp-embedding-en.yaml
- manifests/services/service-nlp-embedding-xx.yaml
- manifests/services/service-nlp-embedding-ge.yaml

# deployments
- manifests/nlp-deployments/service-nlp-embedding-en.yaml
- manifests/nlp-deployments/service-nlp-embedding-xx.yaml
- manifests/nlp-deployments/service-nlp-embedding-ge.yaml

# pod-monitors
- manifests/pod-monitors/service-nlp-embedding-en.yaml
- manifests/pod-monitors/service-nlp-embedding-xx.yaml
- manifests/pod-monitors/service-nlp-embedding-ge.yaml
```