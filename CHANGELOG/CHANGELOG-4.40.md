# 4.40.1

**Important announcement**
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

## Cognigy.AI / Cognigy Insights (core)

The referenced container images have changed.

# 4.40.0

**Important announcement**
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

## Cognigy.AI / Cognigy Insights (core)

The referenced container images have changed.

### Stateful services
To improve the functionality and fix known security vulnerabilities in the dependencies Cognigy.AI/Cognigy Insights uses, we have updated the RabbitMQ from `v3.9.20` to `v3.9.24`.

In this release we have added the option to use custom config file for RabbitMQ. This will allow us to set custom value for memory high watermark for example. Before deploying the new RabbitMQ please deploy the following ConfigMaps that contains the content of the custom configuration of RabbitMQ.

Modify your main `kustomization.yaml` file as we need to load an additional ConfigMaps files:

**Add the following additional Kubernetes ConfigMaps objects into the 'config-maps' section:**

```yaml
# config-maps
...
- manifests/config-maps/cognigy-rabbitmq-config.yaml
```

In case you have modified the Cognigy provided memory limit of the RabbitMQ pod then set your current memory limit in byte to the `total_memory_available_override_value` variable in the `cognigy-rabbitmq-config` ConfigMaps. 
```bash
total_memory_available_override_value = <RabbitMQ_memory_limit_in_byte>
```

If you are using the default memory limit set by Cognigy for the RabbitMQ pod then you don't need to do modify the ConfigMaps.

Current memory high watermark is set to 40% of the RabbitMQ pod memory limit. You can edit this by modifying the `vm_memory_high_watermark.relative` in the `cognigy-rabbitmq-config` ConfigMaps.

```bash
vm_memory_high_watermark.relative = 0.4
```


Updating to this release requires you to update this `stateful services`. Doing this will require restating all application Pods and will come with a couple of seconds of downtime. In order to restart all Pods after you have updated RabbitMQ you can use the following command. Replace the `<target_namespace>` with the namespace name where Cognigy.AI/Cognigy Insights is deployed.

```bash
for i in $(kubectl get deployment --namespace <target_namespace> --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'|grep service-)
do
kubectl --namespace <target_namespace> rollout restart deployment $i
done
```

### Configmap change
In case you are already using the `call capabilities within the Cognigy.AI Interaction Panel`, you have to make sure that you change the following ENV variable in your `config-map_patch` file:
```
VOICE_GATEWAY_PREPARE_CALL_API
```

change the current value from: `/api/v1/call/prepare` to: `/api/v2/call/prepare`.

In addition, you have to set the following additional ENV variable so `Cognigy Live Agent` will be able to display attachments that have been uploaded through Cognigy.AI endpoints:
```
RUNTIME_FILE_MANAGER_CORS_WHITELIST
```

the value should be at least set to the `frontend DNS name` of the `Cognigy Live Agent` installation - an example value would be: `https://dev-live-agent.cognigy.ai`
