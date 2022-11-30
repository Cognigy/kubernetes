# 4.41.0

**Important announcement**
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

## Cognigy.AI / Cognigy Insights (core)

The referenced container images have changed.

### Core (Cognigy.AI)
We have introduced a new Kubernetes secret which you have to apply to your Kubernetes cluster. The secret is called `cognigy-service-endpoint-api-access-token.yaml` and located under `core/template.dist/product/secrets.dist`. We suggest copying this file from the `secrets.dist` folder into your `secrets` folders. The secret value can be a base64 encoded 16 bytes of random hex value.