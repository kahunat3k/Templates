# Brainboard auto-generated file.

resource "google_compute_network" "default" {
  project = data.google_project.default.id
  name    = "lb-vpc"
}

resource "google_compute_subnetwork" "default" {
  project       = data.google_project.default.id
  network       = google_compute_network.default.id
  name          = "lb-subnet"
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_global_address" "default" {
  project = data.google_project.default.id
  name    = "lb-static-ip"
}

resource "google_compute_global_forwarding_rule" "default" {
  target                = google_compute_target_http_proxy.default.id
  project               = data.google_project.default.id
  port_range            = var.fw_rule_port_range
  name                  = "lb-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.default.id
}

resource "google_compute_target_http_proxy" "default" {
  url_map = google_compute_url_map.default.id
  project = data.google_project.default.id
  name    = "lb-target-http-proxy"
}

resource "google_compute_url_map" "default" {
  project         = data.google_project.default.id
  name            = "lb-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  timeout_sec = 10
  protocol    = "HTTP"
  project     = data.google_project.default.id
  port_name   = "brainboard"
  name        = "lb-backend-service"
  enable_cdn  = true

  backend {
    group           = google_compute_instance_group_manager.default.instance_group
    capacity_scaler = 1
  }

  custom_request_headers = [
    "X-Client-Geo-Location: {client_region_subdivision}, {client_city}",
  ]

  custom_response_headers = [
    "X-Cache-Hit: {cdn_cache_status}",
  ]

  health_checks = [
    google_compute_health_check.default.id,
  ]
}

resource "google_compute_firewall" "default" {
  project   = data.google_project.default.id
  network   = google_compute_network.default.id
  name      = "l7-xlb-fw-allow-hc"
  direction = "INGRESS"

  allow {
    protocol = "tcp"
  }

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22",
  ]

  target_tags = [
    "allow-health-check",
  ]
}

resource "google_compute_instance_group_manager" "default" {
  zone               = "us-central1-c"
  target_size        = 2
  project            = data.google_project.default.id
  name               = "lb-mig1"
  base_instance_name = "vm"

  named_port {
    port = 8080
    name = "http"
  }

  version {
    name              = "primary"
    instance_template = google_compute_instance_template.default.id
  }
}

resource "google_compute_health_check" "default" {
  project = data.google_project.default.id
  name    = "lb-hc"

  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_instance_template" "default" {
  project                 = data.google_project.default.id
  metadata_startup_script = <<-EOM
      #! /bin/bash
      set -euo pipefail

      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx-light jq

      NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
      IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")
      METADATA=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/?recursive=True" | jq 'del(.["startup-script"])')

      cat <<EOF > /var/www/html/index.html
      <pre>
      Name: $NAME
      IP: $IP
      Metadata: $METADATA
      </pre>
      EOF
    EOM
  machine_type            = "e2-small"

  disk {
    source_image = "debian-cloud/debian-10"
    boot         = true
    auto_delete  = true
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.id
    network    = google_compute_network.default.id
  }

  tags = [
    "allow-health-check",
  ]
}

data "google_project" "default" {
  project_id = var.project_id
}

