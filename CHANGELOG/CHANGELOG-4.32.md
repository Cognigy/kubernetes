# 4.32.0
## Important announcement
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

## Cognigy.AI / Cognigy Insights (core)
The referenced container images have changed.

In addition, we have `raised CPU limits` for some services in order to fix a problem which are related to older Linux Kernels - you might get these Kernels if you run on e.g. AWS and current Kubernetes versions.

## Stateful services
To improve the functionality and fix known security vulnerabilities in the dependencies Cognigy.AI/Cognigy Insights uses, we have updated the following dependencies:
- Redis, from `v5.0.8` to `v5.0.14`
- RabbitMQ, from `v3.8.3` to `v3.9.20`

Updating to this release requires you to update these `stateful services`. Doing this will require restating all application Pods and will come with a couple of seconds of downtime. In order to restart all Pods after you have updated RabbitMQ, Redis and Redis-persistent, you can use the following command:

```bash
for i in $(kubectl get deployment --namespace <target_namespace> --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'|grep service-)
do
kubectl --namespace <target_namespace> rollout restart deployment $i
done
```