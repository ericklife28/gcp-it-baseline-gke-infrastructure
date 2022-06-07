# ----------------------------------------------------------------------------------------------------------------------
# CREATE SERVICE ACCOUNT
# ----------------------------------------------------------------------------------------------------------------------
resource google_service_account service_account {
  project      = var.gcp_project_id
  account_id   = "${var.name_prefix}-cluster"
  display_name = "Service account used by ${var.name_prefix}-cluster"
}

# ----------------------------------------------------------------------------------------------------------------------
# ADD ROLES TO SERVICE ACCOUNT
# Grant the service account the minimum necessary roles and permissions in order to run the GKE cluster
# plus any other roles added through the 'service_account_roles' variable
# ----------------------------------------------------------------------------------------------------------------------
locals {
  all_service_account_roles = concat(var.service_account_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer"
  ])
}

resource "google_project_iam_member" "service_account_roles" {
  for_each = toset(local.all_service_account_roles)

  project = var.gcp_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}


# ----------------------------------------------------------------------------------------------------------------------
# CREATE GKE CLUSTER
# ----------------------------------------------------------------------------------------------------------------------

resource google_container_cluster cluster {
  provider = google-beta
  project  = var.gcp_project_id
  name     = "${var.name_prefix}-cluster"
  location = var.gcp_location

  remove_default_node_pool  = true
  initial_node_count        = 1
  enable_shielded_nodes     = true
  default_max_pods_per_node = var.default_max_pods_per_node

  workload_identity_config {
    identity_namespace = "${var.gcp_project_id}.svc.id.goog"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  networking_mode = "VPC_NATIVE"
  network         = var.project_network.self_link
  subnetwork      = var.project_subnetwork.self_link

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = var.disable_public_endpoint
    master_global_access_config {
      enabled = true
    }
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }


  dynamic master_authorized_networks_config {
    for_each = var.master_authorized_networks_config
    content {
      dynamic cidr_blocks {
        for_each = lookup(master_authorized_networks_config.value, "cidr_blocks", [])
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
    }
  }
}
