variable "project_name" {
  description = "Google Cloud project ID."
  default = "helmsman-demo"
}

variable "cluster_region" {
  default     = "europe-west1"
  description = "The region where the cluster will be created."
}

variable "cluster_zone" {
  default     = "europe-west1-c"
  description = "The zone where the cluster will be created."
}

variable "cluster_admin_password" {
  description = "password for cluster admin. Must be 16 characters at least."
  default = "fNJCzft4oJWePbNK"
}

# Configure the Google Cloud provider
provider "google" {
  project = "${var.project_name}"
  region  = "${var.cluster_region}"
}

module "cluster" {
  source              = "github.com/ostelco/ostelco-terraform-modules//terraform-google-gke-cluster"
  cluster_password    = "${var.cluster_admin_password}"
  cluster_name        = "demo-cluster"
  cluster_description = "Demo cluster."
  cluster_version     = "1.10.9-gke.5"
  cluster_zone        = "${var.cluster_zone}"
}

module "pool" {
  source         = "github.com/ostelco/ostelco-terraform-modules//terraform-google-gke-node-pool"
  cluster_name   = "${module.cluster.cluster_name}"
  node_pool_zone = "${module.cluster.cluster_zone}"
  initial_node_pool_size = 2


  node_pool_name = "small-nodes-pool"

  node_tags  = ["demo"]

  node_labels = {
    "env"         = "demo"
    "machineType" = "n1-standard-1"
  }
}

output "cluster_endpoint" {
  value = "${module.cluster.cluster_endpoint}"
}

output "cluster_client_certificate" {
  value = "${module.cluster.cluster_client_certificate}"
}

output "cluster_client_key" {
  value = "${module.cluster.cluster_client_key}"
}

output "cluster_ca_certificate" {
  value = "${module.cluster.cluster_ca_certificate}"
}

# the backend config for storing terraform state in GCS 
# requires setting GOOGLE_CREDNETIALS to contain the path to your Google Cloud service account json key.
# terraform {
#   backend "gcs" {
#     bucket = "your-terraform-state"
#     prefix = "cluster/state"
#   }
# }