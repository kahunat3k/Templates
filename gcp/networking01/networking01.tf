# Brainboard auto-generated file.

resource "google_compute_network" "vf-wfmdev-ca-lab-vpc" {
  routing_mode        = "Regional"
  name                = "vf-wfmdev-ca-lab-vpc"
  mtu                 = 1460
  internal_ipv6_range = "disabled"
}

resource "google_compute_subnetwork" "vf-wfmdev-ca-lab-subnet-ie" {
  stack_type               = google_compute_network.vf-wfmdev-ca-lab-vpc.gateway_ipv4
  region                   = "europe-west1"
  private_ip_google_access = true
  network                  = google_compute_network.vf-wfmdev-ca-lab-vpc
  name                     = "vf-wfmdev-ca-lab-subnet-ie"
  ip_cidr_range            = "172.22.24.0/24"
  gateway_address          = "172.22.25.1"
}

resource "google_compute_subnetwork" "vf-wfmdev-ca-lab-subnet-wbs" {
  stack_type               = google_compute_network.vf-wfmdev-ca-lab-vpc.gateway_ipv4
  region                   = "europe-west1"
  private_ip_google_access = true
  network                  = google_compute_network.vf-wfmdev-ca-lab-vpc
  name                     = "vf-wfmdev-ca-lab-subnet-wbs"
  ip_cidr_range            = "172.22.30.0/24"
  gateway_address          = "172.22.26.1"

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "vf-wfmdev-ca-lab-subnet-public" {
  stack_type               = google_compute_network.vf-wfmdev-ca-lab-vpc.gateway_ipv4
  region                   = "europe-west1"
  private_ip_google_access = true
  network                  = google_compute_network.vf-wfmdev-ca-lab-vpc
  name                     = "vf-wfmdev-ca-lab-subnet-public"
  ip_cidr_range            = "172.22.26.0/24"
  gateway_address          = "172.22.26.1"

  log_config {
  }

  secondary_ip_range {
    range_name    = "gke-trusted-zone-gke-pods-da5c5e9e"
    ip_cidr_range = "10.224.0.0/20"
  }
  secondary_ip_range {
    ip_cidr_range = "172.16.5.0/24"
  }
}

resource "google_compute_subnetwork" "vf-wfmdev-ca-lab-subnet-uk" {
  stack_type               = google_compute_network.vf-wfmdev-ca-lab-vpc.gateway_ipv4
  region                   = "europe-west2"
  private_ip_google_access = true
  network                  = google_compute_network.vf-wfmdev-ca-lab-vpc
  name                     = "vf-wfmdev-ca-lab-subnet-uk"
  ip_cidr_range            = "172.22.23.0/24"
  gateway_address          = "172.22.26.1"
}

resource "google_compute_subnetwork" "vf-wfmdev-ca-lab-subnet-de" {
  stack_type               = google_compute_network.vf-wfmdev-ca-lab-vpc.gateway_ipv4
  region                   = "europe-west3"
  private_ip_google_access = true
  network                  = google_compute_network.vf-wfmdev-ca-lab-vpc
  name                     = "vf-wfmdev-ca-lab-subnet-de"
  ip_cidr_range            = "172.22.25.0/24"
  gateway_address          = "172.22.25.1"

  log_config {
    aggregation_interval = "30 sec"
  }
}

resource "google_compute_firewall" "allow-internal-dataproc-de-egress" {
  priority       = 1000
  network        = google_compute_network.vf-wfmdev-ca-lab-vpc
  name           = "allow-internal-dataproc-de-egress"
  enable_logging = true
  disabled       = false
  direction      = "Egress"

  allow {
    protocol = "icmp,tcp,udp"
  }

  destination_ranges = [
    "66.102.1.0/24",
    "74.125.71.0/24",
    "172.22.25.0/24",
  ]
}

resource "google_compute_firewall" "allow-google-apis-egress-private" {
  priority       = 1000
  network        = google_compute_network.vf-wfmdev-ca-lab-vpc
  name           = "allow-google-apis-egress-private"
  enable_logging = true
  disabled       = false
  direction      = "Egress"

  allow {
    protocol = "tcp"
  }

  destination_ranges = [
    "199.36.153.8/30",
  ]
}

resource "google_compute_firewall" " allow-internal-dataproc-ie" {
  priority       = 1000
  network        = google_compute_network.vf-wfmdev-ca-lab-vpc
  name           = " allow-internal-dataproc-ie"
  enable_logging = false
  disabled       = false
  direction      = "Ingress"

  allow {
    protocol = "icmp,tcp,udp"
  }

  source_ranges = [
    "172.22.24.0/24",
  ]

  target_tags = [
    "allow-internal-dataproc-ie",
  ]
}

resource "google_compute_firewall" "allow-internal-dataproc-wbs-egress" {
  priority       = 1000
  network        = google_compute_network.vf-wfmdev-ca-lab-vpc
  name           = "allow-internal-dataproc-wbs-egress"
  enable_logging = true
  disabled       = false
  direction      = "Egress"

  allow {
    protocol = "icmp,tcp,udp"
  }

  destination_ranges = [
    "66.102.1.0/24",
    "172.22.30.0/24",
    "74.125.71.0/24",
  ]

  target_tags = [
    "allow-internal-dataproc-wbs",
  ]
}

