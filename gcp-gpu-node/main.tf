provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "gpu_node" {
  name         = "${var.node_name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  tags = ["gpu"]

  scheduling {
    automatic_restart = false
    on_host_maintenance = "TERMINATE"
  }

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size = 64
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    access_config {}

    network = "${var.network}"
  }

  metadata {
//    startup-script= "${file("startup.sh")}"
    startup-script = <<STARTUP
${file("${path.module}/setup.sh")}
${file("${path.module}/cuda.sh")}
${file("${path.module}/cudapython.sh")}
${file("${path.module}/julia.sh")}
${file("${path.module}/kokkos.sh")}
STARTUP
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  guest_accelerator {
    type = "${var.accelerator_type}"
    count = "${var.accelerator_count}"
  }
}
