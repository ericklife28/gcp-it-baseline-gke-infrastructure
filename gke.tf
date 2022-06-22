
data "terraform_remote_state" "trs_net_vpcs" {
  backend = "gcs"
  config = {
    bucket = "${var.organization}-gcs-it-trf-net-eus1-001"
    prefix = "gcp-it-baseline-networking-vcp/net"
  }
}



module gke_cluster {
  count                         = var.deploy ? 1 : 0
  source                        = "./modules/gke_cluster"
  gcp_project_id                = var.gcp_project_id
  name_prefix                   = "k8s"
  gcp_location                  = var.gcp_zone
  project_network               = data.terraform_remote_state.services.outputs.network
  project_subnetwork            = data.terraform_remote_state.services.outputs.subnetwork
  cluster_secondary_range_name  = data.terraform_remote_state.services.outputs.secondary_range_name
  services_secondary_range_name = data.terraform_remote_state.services.outputs.tertiary_range_name
  disable_public_endpoint       = false
  master_ipv4_cidr_block        = "192.168.0.0/28"
  default_max_pods_per_node     = 32
  master_authorized_networks_config = [{
    cidr_blocks = [{
      cidr_block   = "10.0.0.0/8"
      display_name = "internal_network"
      }, {
      cidr_block   = "166.108.0.0/16"
      display_name = "mcc_network"
    }]
  }]
}
