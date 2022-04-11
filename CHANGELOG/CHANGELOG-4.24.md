# 4.24.0
## Cognigy.AI (core)
This release does not only change the referenced container images, but also brings a new microservice called ``service-session-state-management``. In order for all of this to work properly, we have to do the following three steps:
- create the new database in the MongoDB database server
- fill-in the values into the new Kubernetes secret which stores a connection-string so the new microservice can connect to the new database
- modify the kustomization.yaml in our product(s) folder(s) so the new microservice will be started as well

### Create the new database
Connect to your MongoDB database server in order to create the new database as well as a user with read/write permissions for it. Depending on how you setup the database server in the first place (e.g. self-hosted vs MongoDB Atlas), connecting to the database looks different.

Once you are connected to the PRIMARY, please run the following statement (make sure you replace the ``<password>`` section accordingly):

```
use service-session-state-manager
db.createUser({
	user: "service-session-state-manager",
	pwd: "<password>",
	roles: [
		{ role: "readWrite", db: "service-session-state-manager" }
	]
});
```

This will create a new user, create a new database and give the user read/write permissions for the new database. Please note-down the ``<password>`` as you will need this in the next step.

### Create new Kubernetes secret
A template for the new secret is stored in `core/template.dist/product/secrets.dist`. Please copy this file and insert it into your `secrets` folder - e.g. located under `core/development/product/secrets`. Insert the file into the new location and open it in a text editor. The file should look like this:

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: cognigy-service-session-state-manager
type: Opaque
data:
    # The full mongodb connection string, has a schema of:
    # mongodb://service-session-state-manager:<password>@<host>:<port>/xx or different for replica-set
    connection-string:

    # use 64 bytes of random value, hex
    # db-password: 
```

You now have to build the proper connection string pointing to the database. A connection string in MongoDB follows this pattern:

```
mongodb://<username>:<password>@<hostnames>:<port>/<database-name>
```

Depending on whether you are using a locale MongoDB, an external 3-node replica-set or a MongoDB Atlas instance, the connection string will look different. We highly suggest checkign e.g. how your `cognigy-service-ai` Kubernetes secret looks like. You can copy the `connection-string` from another Kubernetes secret and `base64 decode` it. Then apply build up your new connection string for this new service, base64 encode it and and fill the base64 encoded variant into the new file you have created.

Make sure you also `apply it to your cluster` via the usage of `kubectl apply -f`.

### Adjustments in kustomization.yaml
Please have a look at the adjusted ``kustomization.yaml`` file located under ``core/template.dist/product/kustomization.yaml``. You will see that it contains a new line which loads the additional deployment - the section of this file looks similar to the following:

```yaml
- manifests/deployments/service-security.yaml
- manifests/deployments/service-session-state-manager.yaml
- manifests/deployments/service-task-manager.yaml
```

Please apply the same change to your own copy of ``kustomization.yaml`` in order to ensure that this new microservice will be started when updating to Cognigy.AI v4.24.0

**You should now be good to start the Cognigy.AI v4.24.0 release. In case of questions, please get in touch with us BEFORE you start with the actual update command.**