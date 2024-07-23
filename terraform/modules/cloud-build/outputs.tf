output "connection_name" {
  value = google_cloudbuildv2_connection.my-connection.name
}

output "connection_project" {
  value = google_cloudbuildv2_connection.my-connection.project
}

output "connection_region" {
  value = google_cloudbuildv2_connection.my-connection.location
}

output "repo" {
  value = var.repo
}
