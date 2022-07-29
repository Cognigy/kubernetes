# 4.32.0
## Important announcement
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

## Cognigy.AI / Cognigy Insights (core)
The referenced container images have changed.

## Stateful services
To improve the functionality and reduce the number of vulnerabilities, in the release `4.30.2` we have updated the Redis from v5.0.8 to v5.0.14 and RabbitMQ from v3.8.3 to v3.9.20. There might be a service fluctuation for a few seconds. Once the new RabbitMQ pod is up and running, in order to establish the inter component communication properly, please restart all the Cognigy services.


You can use the following command with proper namespace to restart the services

```bash
for i in $(kubectl get deployment --namespace <target_namespace> --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'|grep service-)
do
kubectl --namespace <target_namespace> rollout restart deployment $i
done
```
