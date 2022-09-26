# 4.36.0

## Preparing upcoming services
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