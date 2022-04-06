# 4.23.0
## Cognigy.AI (core)
This release does not only change the referenced container images, but also brings a new microservice called ``service-playbook-execution``.

Please have a look at the adjusted ``kustomization.yaml`` file located under ``core/template.dist/product/kustomization.yaml``. You will see that it contains a new line which loads the additional deployment - the section of this file looks similar to the following:

```yaml
- ...
- manifests/deployments/service-parser.yaml
- manifests/deployments/service-playbook-execution.yaml
- manifests/deployments/service-profiles.yaml
- ...
```

Please apply the same change to your own copy of ``kustomization.yaml`` in order to ensure that this new microservice will be started when updating to Cognigy.AI v4.23.0