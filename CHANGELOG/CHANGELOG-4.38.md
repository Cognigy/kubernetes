# 4.38.0

**Important announcement**
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

## Cognigy.AI / Cognigy Insights (core)

The referenced container images have changed.

### Removed microservice

This release of Cognigy.AI / Cognigy Insights removes `service-analytics-realtime` - a component which is no longer used. Please make sure you remove it from your `kustomization.yaml` file in your respective `product` folder.

You can manually remove the deployment after you have successfully upgraded to `v4.38.0` with the following command:

```
kubectl delete deployment service-analytics-realtime
```
