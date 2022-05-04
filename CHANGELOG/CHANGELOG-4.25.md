# 4.25.0
## Cognigy.AI (core)
The referenced container images have changed.

We have also adjusted the deployment files for `service-handover` and `service-ui`. Please make sure that you have read the changelog for `release v4.17.0` in which we have mentioned a new Kubernetes secret which you have to apply to your Kubernetes cluster in order to have a fully working installation.

## Cognigy Insights
Cognigy Insights will, as usual, be deployed as part of Cognigy.AI in the files located in the "core" folder.

We have created additional database indices for the `analytics` and `sessions` collection in two different Cognigy Insights databases. Depending on the amount of data you already have in these collections, you might experience a slight slowdown of the system while MongoDB creates the new indices.