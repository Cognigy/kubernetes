# 4.32.0
## Important announcement
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

## Cognigy.AI / Cognigy Insights (core)
The referenced container images have changed.

### CPU limits
In addition, we have `raised CPU limits` for some services in order to fix a problem which are related to older Linux Kernels - you might get these Kernels if you run on e.g. AWS and current Kubernetes versions.

### New services
You will also see that this release introduces two new microservices:
- service-insights-ui
- service-insights-api

We are slowly separating Cognigy.Insights from Cognigy.AI in order to improve scalability, stability and performance of both products. To prepare your installation, please follow these steps closely in order to make sure that the upgrade is smooth:

1. Create a new DNS entry for `service-insights-api` and point it towards your loadbalancer which was provisioned when you have installed Cognigy.AI. A potential example would be the following:

    Let's assume that your `Cognigy.AI API` is available on the DNS name `api-trial.cognigy.ai` a good name for the new Insights API service would be `insights-api-trial.cognigy.ai` - so we e.g. just prefix the Cognigy.AI API address with `insights-`.

    Using a command like `dig` on Linux should reveal that both DNS names point to the same Loadbalancer address:

    ```
    dig api-trial.cognigy.ai

    ; <<>> DiG 9.10.6 <<>> trial.cognigy.ai
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26015
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1
    
    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 1232
    ;; QUESTION SECTION:
    ;trial.cognigy.ai.              IN      A
    
    ;; ANSWER SECTION:
    trial.cognigy.ai.       300     IN      CNAME   ae79c0ec73eca4d64a0509f7a75fe42a-1344350581.eu-central-1.elb.amazonaws.com.
    ae79c0ec73eca4d64a0509f7a75fe42a-1344350581.eu-central-1.elb.amazonaws.com. 60 IN A 52.29.55.202
    ae79c0ec73eca4d64a0509f7a75fe42a-1344350581.eu-central-1.elb.amazonaws.com. 60 IN A 3.121.18.227
    ae79c0ec73eca4d64a0509f7a75fe42a-1344350581.eu-central-1.elb.amazonaws.com. 60 IN A 3.64.138.183
    
    ;; Query time: 30 msec
    ;; SERVER: 192.168.0.1#53(192.168.0.1)
    ;; WHEN: Wed Aug 10 18:37:42 CEST 2022
    ;; MSG SIZE  rcvd: 181
    ```

    Performing the same `dig` command for the new Insights API server should return similar data.

2. Create random data for the new `cognigy-insights-jwt` secret which is stored in `template.dist/product/secrets.dist`. Copy the template file into your proper `secrets` folder and fill in a random value + base64 encode it - the following would be an example of a file **(please don't use this file for security reasons)**:
    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: cognigy-insights-jwt
    type: Opaque
    data:
      # use 128 bytes of random value, hex
      secret: OGRkNTYyNmYyMmFlMDU4MjljNTI4YjUwN2IzZDdiOTM0ODI5MzY4NTc4NTRjY2Q5OGMwMGE3NTk3NTlmZWJhN2I2NjAyMDU2YTFiYTY2NjM4MWRlOTNkMjg5ZDQ3Mzc3MDMwMWRjOTgyNjY4MGM4ZDIzNGI2NjJjNGM2YzMyMjc=
    ```

    Apply this file to your Kubernetes cluster using:
    ```bash
    kubectl apply -f cognigy-insights-jwt.yaml
    ```

    This secret will be mounted by:
    - service-api (Cognigy.AI microservice)
    - service-insights-api (Cognigy Insights microservice)

3. Modify your main `kustomization.yaml` file as we need to add a couple of lines to it:

    **Add these two new Kubernetes Service objects in the 'services' section**:
    ```yaml
    ...
    # services
    - manifests/services/service-analytics-odata.yaml
    - manifests/services/service-api.yaml
    - manifests/services/service-endpoint.yaml
    - manifests/services/service-ui.yaml
    - manifests/services/service-webchat.yaml

    - manifests/services/service-insights-api.yaml
    - manifests/services/service-insights-ui.yaml
    ```

    **Add these two new Kubernetes Deployment objects in the 'deployments' section**:
    ```yaml
    # deployments
    ...
    - manifests/deployments/service-ui.yaml
    - manifests/deployments/service-webchat.yaml

    - manifests/deployments/service-insights-api.yaml
    - manifests/deployments/service-insights-ui.yaml
    ```

    **Add these two new Kubernetes Ingress objects in the 'reverse proxy' section**:
    ```yaml
    # reverse proxy
    - manifests/reverse-proxy/deployments/traefik.yaml
    - manifests/reverse-proxy/deployments/traefik-crd.yaml
    - manifests/reverse-proxy/deployments/traefik_tlsoption.yaml
    - manifests/reverse-proxy/deployments/traefik-middleware-ipwhitelist.yaml
    - manifests/reverse-proxy/ingress/service-analytics-odata.yaml
    - manifests/reverse-proxy/ingress/service-api.yaml
    - manifests/reverse-proxy/ingress/service-endpoint.yaml
    - manifests/reverse-proxy/ingress/service-ui.yaml
    - manifests/reverse-proxy/ingress/service-webchat.yaml

    - manifests/reverse-proxy/ingress/service-insights-api.yaml
    - manifests/reverse-proxy/ingress/service-insights-ui.yaml

    - manifests/reverse-proxy/services/traefik.yaml
    ```

4. Create new patch files to patch `service-insights-ui` and `service-insights-api` DNS names accordingly so they match the DNS names of your installation.

    Create a new file called `service-insights-ui_patch.yaml` in the folder `core/<your_environment>/product/overlays/reverse-proxy/ingress` and add the following content (replace <your-ui-DNS-name> accordingly):
    ```yaml
    - op: add
      path: /spec/rules/0/host
      value: "<your-ui-DNS-name>"
    ```

    **Important: The service-insights-ui Ingress re-uses the same DNS name than service-ui uses! So you have to provide the same name above!!**

    Create a new file called `service-insights-api_patch.yaml` in the folder `core/<your_environment>/product/overlays/reverse-proxy/ingress` and add the following content (replace <your-insights-api-DNS-name> accordingly):
    ```yaml
    - op: add
      path: /spec/rules/0/host
      value: "<your-insights-api-DNS-name>"
    ```

5. You now have to load the two `patch files` we have created above - go back to your `kustomization.yaml` and add the following content at the bottom of the file where we already load other patches:
    ```yaml
    ...
    - target:
        group: networking.k8s.io
        version: v1
        kind: Ingress
        name: service-webchat
      path: overlays/reverse-proxy/ingress/service-webchat_patch.yaml

    - target:
        group: networking.k8s.io
        version: v1
        kind: Ingress
        name: service-insights-api
      path: overlays/ingress/service-insights-api_patch.yaml

    - target:
        group: networking.k8s.io
        version: v1
        kind: Ingress
        name: service-insights-ui
      path: overlays/ingress/service-insights-ui_patch.yaml
    ```

6. Adjust your `replica_count.yaml` file accordingly - add the `service-insights-api` and `service-insights-ui` Deployments and specify the replica-count - e.g. 3.

7. The last step is that you have to manipulate the `config-map_patch.yaml` file in which your application configuration is listed.

    More at the top of the file you have a section `#DNS names` in which you have to additionally list the new `insights-api` DNS name - the following shows an example of one of our environments:
    ```yaml
    # DNS names
    ...
    - op: add
      path: /data/INSIGHTS_BACKEND_BASE_URL_WITH_PROTOCOL
      value: "https://insights-api-trial.cognigy.ai"
    ```

    At the bottom of the file you are usually activating feature flags - please add the following:
    ```yaml
    # activate using the new insights ui
    - op: add
      path: /data/FEATURE_USE_SERVICE_INSIGHTS_UI
      value: "true"
    ```

Please **double check** all changes above. If everything looks good, you can go ahead with the normal update procedure and update to v4.32.0.


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