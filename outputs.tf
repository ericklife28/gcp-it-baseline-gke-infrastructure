output "service_account_nonprod_id" {
  value = google_service_account.service_account_nonprod.id
}

output "service_account_prod_id" {
  value = google_service_account.service_account_prod.id
}

output "service_account_build_id" {
  value = google_service_account.service_account_build.id
}