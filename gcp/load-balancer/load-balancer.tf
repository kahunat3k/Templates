# Brainboard auto-generated file.

resource "google_compute_global_address" "default" {
  name       = "${var.name}-address"
  ip_version = var.ip_version
}

resource "google_compute_ssl_certificate" "default" {
  private_key = var.private_key
  name_prefix = "${var.name}-certificate-"
  certificate = var.certificate

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_target_https_proxy" "default" {
  url_map          = google_compute_url_map.https_redirect.self_link
  ssl_policy       = var.ssl_policy
  ssl_certificates = compact(concat(var.ssl_certificates, google_compute_ssl_certificate.default.*.self_link, ), )
  quic_override    = var.quic ? "ENABLE" : null
  name             = "${var.name}-https-proxy"
}

resource "google_compute_firewall" "default-hc" {
  target_tags = var.target_tags
  network     = var.firewall_networks[0]
  name        = "${var.name}-hc"

  allow {
    protocol = "tcp"
    ports = [
      "80",
      "443",
    ]
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
}

resource "google_compute_url_map" "default" {
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_global_forwarding_rule" "http" {
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
  name       = var.name
  ip_address = google_compute_global_address.default.address
}

resource "google_compute_global_forwarding_rule" "https" {
  target     = google_compute_target_https_proxy.default.self_link
  port_range = "80"
  name       = "${var.name}-https"
  ip_address = google_compute_global_address.default.address
}

resource "google_compute_health_check" "health_check" {
  unhealthy_threshold = 2
  timeout_sec         = 5
  name                = "${var.name}-hc"
  healthy_threshold   = 2
  check_interval_sec  = 5

  https_health_check {
    port = 443
  }
}

resource "google_compute_target_http_proxy" "default" {
  url_map = google_compute_url_map.https_redirect.self_link
  name    = "${var.name}-http-proxy"
}

resource "google_compute_backend_service" "default" {
  name       = "${var.name}-backend"
  enable_cdn = true

  depends_on = [
    google_compute_health_check.health_check,
  ]

  health_checks = [
    google_compute_health_check.health_check.self_link,
  ]
}

resource "google_compute_url_map" "https_redirect" {
  name = "${var.name}-https-redirect"

  default_url_redirect {
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    https_redirect         = true
  }
}

