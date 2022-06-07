output name {
  # This may seem redundant with the `name` input, but it serves an important
  # purpose. Terraform won't establish a dependency graph without this to interpolate on.
  description = "The name of the cluster master. This output is used for interpolation with node pools, other modules."

  value = google_container_cluster.cluster.name
}

output master_version {
  description = "The Kubernetes master version."
  value       = google_container_cluster.cluster.master_version
}

output endpoint {
  description = "The IP address of the cluster master."
  sensitive   = true
  value       = google_container_cluster.cluster.endpoint
}


output cluster_ca_certificate {
  description = "The public certificate that is the root of trust for the cluster."
  value       = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
}

output service_account_email {
  # This may seem redundant with the `name` input, but it serves an important
  # purpose. Terraform won't establish a dependency graph without this to interpolate on.
  description = "The email address of the custom service account."
  value       = google_service_account.service_account.email
}

output node_selector {
  description = "Name of node selector that deployed applications will look for in the label 'node_selector'"
  value = lookup(google_container_node_pool.pool.node_config.0.labels,"node_selector","")
}

