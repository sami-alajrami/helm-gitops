## Initialization

> This step requires gcloud authentication. And you need to change the parameters in the script to your own.
Run `./init.sh` to configure k8s connection and initialize helm.

## Testing Helm

`helm repo list`

`helm search jenkins`

`helm install stable/jenkins --namespace demo --name jenkins`

`helm upgrade jenkins stable/jenkins --set Master.ImageTag=2.145-slim`

`helm history jenkins`

`helm rollback jenkins` 


## Clean up

Run `./doomsday.sh` to destroy all resources inside the cluster.
