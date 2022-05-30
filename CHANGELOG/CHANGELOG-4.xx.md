# 4.xx.0
## Cognigy.AI (core)
The referenced container images have changed.

New deployment `service-app-session-manager`  New Ingress, new Service
- core/development/product/manifests/services/service-app-session-manager.yaml
- core/development/product/manifests/deployments/service-app-session-manager.yaml
- core/development/product/manifests/reverse-proxy/ingress/service-app-session-manager.yaml
- core/development/product/overlays/reverse-proxy/ingress/service-app-session-manager_patch.yaml

New deployment `service-static-files`  New Ingress, new Service
- core/development/product/manifests/services/service-static-files.yaml
- core/development/product/manifests/deployments/service-static-files.yaml
- core/development/product/manifests/reverse-proxy/ingress/service-static-files.yaml
- core/development/product/overlays/reverse-proxy/ingress/service-static-files_patch.yaml

### Kustomization
```yaml
# services
- manifests/services/service-app-session-manager.yaml
- manifests/services/service-static-files.yaml

# deployments
- manifests/deployments/service-app-session-manager.yaml
- manifests/deployments/service-static-files.yaml

# reverse-proxy
- manifests/reverse-proxy/ingress/service-app-session-manager.yaml
- manifests/reverse-proxy/ingress/service-static-files.yaml

patchesJson6902:
# reverse-proxy, ingress

- target:
    group: extensions
    version: v1beta1
    kind: Ingress
    name: service-app-session-manager
  path: overlays/reverse-proxy/ingress/service-app-session-manager_patch.yaml

- target:
    group: extensions
    version: v1beta1
    kind: Ingress
    name: service-static-files
  path: overlays/reverse-proxy/ingress/service-static-files_patch.yaml
```