# Brainboard auto-generated file.

resource "google_compute_network" "network" {
  routing_mode = var.routing_mode
  project      = google_project.project.id
  name         = var.network_name
  description  = var.description
}

resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  project = google_project.project.id
  count   = var.shared_vpc_host ? 1 : 0

  depends_on = [
    google_compute_network.network,
  ]
}

resource "google_project" "project" {
  project_id = var.project_id
  name       = "default-project"
}

