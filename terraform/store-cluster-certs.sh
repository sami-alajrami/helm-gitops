#!/bin/bash
# This script extracts the keys/certs needed to authenticate to the cluster endpoint
# These secrets are needed when configuring kubectl manually (without the magical gcloud command)
# They will be used by Helmsman to connect to the cluster, and therefore need to be always updated in the GCS bucket
# each time terraform is applied.

# defining the bucket where the secrets are stored.
GCS_BUCKET=gs://helmsman-demo-k8s-key-store




# saving the scecrets into files
echo "Importing keys from terraform into local files ... "

mkdir keys
echo $(terraform output cluster_client_certificate) | base64 --decode > keys/cluster_client_certificate.crt
echo $(terraform output cluster_client_key) | base64 --decode > keys/cluster_client_key.key
echo $(terraform output cluster_ca_certificate) | base64 --decode > keys/cluster_ca.crt

# push secrets to GCS and cleanup the local file system
if [[ -r keys/cluster_client_certificate.crt ]] && [[ -r keys/cluster_client_key.key ]] && [[ -r keys/cluster_ca.crt ]];then
  echo "Keys found. Pushing keys to GCS ... "
  gsutil cp -r keys  ${GCS_BUCKET}
  if [ $? -ne 0 ] ; then
    echo "Could not copy keys to GCS bucket."
    exit 1
  else
    echo "Cleaning up local file system ... "
    rm -fr keys && echo "Keys cleanup complete." || echo "Something went wrong during keys cleanup."
  fi

else
  echo "Something went wrong with reading terraform output variables! The files (or some of them) are empty. Deleting local keys directory, and aborting!"
  rm -fr keys
  exit 1
fi