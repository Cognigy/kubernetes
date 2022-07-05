# 4.29.0
## Cognigy.AI / Cognigy Insights (core)
The referenced container images have changed.

This release also introduces a couple of new files which are not relevant, yet. So please ignore the following files:

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

**The new files are only here as we prepare some changes for future Cognigy.AI versions - you can ignore them for now as we will mention changes as soon as they are relevant.**