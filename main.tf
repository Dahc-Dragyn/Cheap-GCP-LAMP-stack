terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "your-project-id"  # Replace with your GCP project ID
  region  = "us-central1"     # Choose a region
  zone    = "us-central1-a"   # Choose a zone within the region
}

# Create a VPC network
resource "google_compute_network" "main" {
  name                    = "lamp-network"
  auto_create_subnetworks = false
}

# Create a subnet
resource "google_compute_subnetwork" "main" {
  name          = "lamp-subnet"
  ip_cidr_range = "10.128.0.0/20"
  region        = "us-central1"
  network       = google_compute_network.main.name
}

# Create a firewall rule to allow HTTP traffic
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Create a firewall rule to allow HTTPS traffic
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Create a Compute Engine instance (VM)
resource "google_compute_instance" "lamp_instance" {
  name         = "lamp-server"
  machine_type = "e2-micro"  # Cheapest general-purpose machine type
  zone         = "us-central1-a"
  tags         = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Use a Debian image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.name
    access_config {
    }
  }

  # Install Apache, MySQL, and PHP using a startup script
  metadata_startup_script = <<EOF
#!/bin/bash
apt-get update
apt-get install -y apache2 mysql-server php php-mysql
systemctl restart apache2
EOF
}
