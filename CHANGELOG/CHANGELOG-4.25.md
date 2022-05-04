# 4.25.0
## Cognigy.AI (core)
The referenced container images have changed.

Document change in service-ui + service-handover deployment as additional secrets needs to be present - otherwise the deployment will not be able to spawn pods

## Cognigy Insights
Cognigy Insights will, as usual, be deployed as part of Cognigy.AI in the files located in the "core" folder.

We have created additional database indices for the `analytics` and `sessions` collection in two different Cognigy Insights databases. Depending on the amount of data you already have in these collections, you might experience a slight slowdown of the system while MongoDB creates the new indices.