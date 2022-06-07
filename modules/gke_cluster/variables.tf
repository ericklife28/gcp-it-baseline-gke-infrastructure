variable gcp_project_id {
  description = "The project for this network"
  type        = string
}

variable name_prefix {
  description = "The prefisx for the cluster's name"
  type        = string
}

variable gcp_location {
  description = "The location which the instances are created. It can be a region or a zone"
  type        = string
  default     = "us-east1-b"
}


variable project_network {
  description = "VPC Network to use for instances"
  type = object({
    self_link = string
    name      = string
    id        = string
  })
}

variable project_subnetwork {
  description = "VPC subnet for user instances"
  type = object({
    self_link = string
    name      = string
    id        = string
  })
}

variable cluster_secondary_range_name {
  description = "The name of the secondary range within the subnetwork for the cluster to use"
  type        = string
}


variable services_secondary_range_name {
  description = "The name of the secondary range within the subnetwork for the services to use"
  type        = string
}


variable master_ipv4_cidr_block {
  description = "The IP range in CIDR notation to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
  default     = "192.168.0.0/28"
}


variable master_authorized_networks_config {
  description = <<EOF
  The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)
  ### example format ###
  master_authorized_networks_config = [{
    cidr_blocks = [{
      cidr_block   = "10.0.0.0/8"
      display_name = "example_network"
    }],
  }]
EOF
  type        = list(any)
  default     = []
}


variable disable_public_endpoint {
  description = "Control whether the master's internal IP address is used as the cluster endpoint. If set to 'true', the master can only be accessed from internal IP addresses."
  type        = bool
  default     = true
}

variable default_max_pods_per_node {
  description = "Establish the max quantity of pods per node, it is related  with the  cluster_secondary_range_name value, for additonal info review https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr"
  type        = number
}

variable service_account_roles {
  description = "Additional roles to be added to the service account."
  type        = list(string)
  default     = []
}

variable initial_node_count {
  description = "How many initial nodes in the new node pool."
  type        = number
  default     = 1
}

variable min_node_count {
  description = "Minimum node count in the node pool."
  type        = number
  default     = 1
}

variable max_node_count {
  description = "Maximum node count in the node pool."
  type        = number
  default     = 1
}

variable nodepool_image_type {
  description = "Node pool image type"
  type        = string
  default     = "COS"
}

variable nodepool_machine_type {
  description = "Node pool machine type"
  type        = string
  default     = "n1-standard-2"
}

variable nodepool_labels {
  description = "Labels to apply to the node pool"
  type        = map(string)
  default     = {}
}

variable nodepool_preemptible {
  description = "Allow nodes in pool to be preempted"
  type        = bool
  default     = true
}

variable node_selector {
  description = "Name of node selector that deployed applications will look for in the label 'node_selector'"
  type        = string
  default     = "main_pool"
}

