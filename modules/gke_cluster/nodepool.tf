resource google_container_node_pool pool {
  provider = google-beta
  name     = "${var.name_prefix}-pool"
  project  = var.gcp_project_id
  location = var.gcp_location
  cluster  = google_container_cluster.cluster.name

  initial_node_count = var.initial_node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    image_type      = var.nodepool_image_type
    machine_type    = var.nodepool_machine_type
    labels          = merge(var.nodepool_labels, { node_selector = var.node_selector })
    preemptible     = var.nodepool_preemptible
    service_account = google_service_account.service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

