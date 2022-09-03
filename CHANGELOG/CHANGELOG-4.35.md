# 4.35.0
## Important announcement
With release `4.30.0` we have started to mark this repository as `deprecated`. If you are an `on-premise` customer and you are running Cognigy.AI/Cognigy Insights yourself, please have a look at our [Helm Chart](https://github.com/cognigy/cognigy-ai-helm-chart) which we have crated for Cognigy.AI/Cognigy Insights! This kubernetes repository will still remove updates `until 31st December 2022`.

**Please start migration to the Cognigy.AI/Cognigy Insights HelmChart**.

## Cognigy.AI / Cognigy Insights (core)
The referenced container images have changed.


Todo: Mention that Cognigy Apps assets are there but should not be used!

### New services
You will see that this release introduces a new microservice:
- service-runtime-file-manager

This microservices offers file-upload capabilities which are e.g. used in our new `Whatsapp Cloud` Endpoint. To prepare your installation, please follow these steps closely in order to make sure that the upgrade is smooth:

1. Create a new DNS entry for `service-runtime-file-manager` and point it towards your loadbalancer which was provisioned when you have installed Cognigy.AI. A potential example would be the following:

    Let's assume that your `Cognigy.AI API` is available on the DNS name `api-trial.cognigy.ai` a good name for this new runtime file manager API service would be `files-api-trial.cognigy.ai` - so we e.g. just prefix the Cognigy.AI API address with `files-`.

    Using a command like `dig` on Linux should reveal that both DNS names point to the same loadbalancer address:

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

    Performing the same `dig` command for the new files API server should return similar data.

2. The new services needs a new database in the database-server. Please connect to your `MongoDB primary` and create a new dataase and database user with the following command - be sure that you actually replace `<password>` with a secure and long password:

    ```
    use service-runtime-file-manager
    db.createUser({
    	user: "service-runtime-file-manager",
    	pwd: "<password>",
    	roles: [
    		{ role: "readWrite", db: "service-runtime-file-manager" }
    	]
    });
    ```

3. You now have to create a new Kubernetes secret for the new password. Please copy the new file `cognigy-service-runtime-file-manager.yaml` from `core/template.dist/product/secrets.dist` to your folder where your actual secrets are stored.

    Make sure that you build a proper `MongoDB connection string` which needs to be valid for your MongoDB configuration. Depending on how many members you have in your replica-set, the DNS list might e.g. look different. Be sure that you use the correct password you have created above `when creating the database and database user` in the database server.

4. Modify your main `kustomization.yaml` file as we need to load a couple of additional files:

    **Add the following additional Kubernetes Configmap objects into the 'config-maps' section:**

    ```yaml
    # config-maps
    ...
    - manifests/config-maps/clamav.yaml
    ```

    **Add these two new Kubernetes Service objects into the 'services' section:**

    ```yaml
    # services
    ...
    - manifests/services/clamd.yaml
    - manifests/services/service-runtime-file-manager.yaml
    ...
    ```

    **Add the following new Kubernetes Deployment object into the 'deployments' section:**

    ```yaml
    # deployments
    ...
    - manifests/deployments/service-runtime-file-manager.yaml
    ...
    ```

    **Create a new section 'deamonsets' under the 'deployments' section:**

    ```yaml
    # daemon-sets
    - manifests/daemon-sets/clamd.yaml
    ```

    **Add the following new Kubernetes ingress object into the 'reverse proxy' section:**

    ```yaml
    # reverse-proxy
    ...
    - manifests/reverse-proxy/ingress/service-runtime-file-manager.yaml
    ...
    ```

5. Create a new patch file to patch the `service-runtime-file-manager` DNS name accordingly so it matches the DNS name of your installation:

    Create a new file called `service-runtime-file-manager_patch.yaml` in the folder `core/<your_environment>/product/overlays/reverse-proxy/ingress` and add the following content (replace accordingly):

    ```yaml
    - op: add
      path: /spec/rules/0/host
      value: "<your-files-api-DNS-name>"
    ```

6. You now have to load the `patch file` we have created above - go back to your `kustomization.yaml` and add the following content at the bottom of the file where we load other patches:

    ```yaml
    ...
    - target:
        group: networking.k8s.io
        version: v1
        kind: Ingress
        name: service-runtime-file-manager
      path: overlays/reverse-proxy/ingress/service-runtime-file-manager_patch.yaml
    ```

7. Adjust the `replica_count.yaml` file accordingly - add the `service-runtime-file-manager` Deployment and specifh the replica-count - e.g. 3.

8. The last step is that you have to manipulate your `config-map_patch.yaml` file in which your application configuration is listed.

    At the top of the file you should have `#DNS names` in which you have to additionally add the new DNS name you have created:

    ```yaml
    - op: add
      path: /data/RUNTIME_FILE_MANAGER_BASE_URL_WITH_PROTOCOL
      value: "https://files-api-trial.cognigy.ai"
    ```

Please **double check** all changes above. If everything looks good, you can go ahead with the normal update procedure and update to v4.35.0.


## Healthcheck & Environment Changes
We have adjusted the Liveness Probes in the following services:
 - service-function-execution
 - service-function-scheduler
 - service-http
 - service-nlp-matcher
 - service-profiles
 - service-resources
 - service-nlp-score-<language>
 - service-nlp-train-<language>

We have also added environment variables for Redis + RabbitMQ reconnection logic in the following services:

- service-ai
- service-app-session-manager
- service-endpoint
- service-execution
- service-function-execution
- service-function-scheduler
- service-http
- service-nlp-matcher
- service-nlp-ner
- service-playbook-execution
- service-profiles
- service-resources
- service-session-state-manager