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
    startup-script = <<STARTUP
${file("${path.module}/startup.sh")}
STARTUP

    anaconda3-unit = <<ANACONDA3UNIT
${file("${path.module}/anaconda3.service")}
ANACONDA3UNIT

    cudapython-path = <<CUDAPYTHONPATH
${file("${path.module}/cudapython.path")}
CUDAPYTHONPATH

    cudapython-unit = <<CUDAPYTHONUNIT
${file("${path.module}/cudapython.service")}
CUDAPYTHONUNIT

    julia-unit = <<JULIAUNIT
${file("${path.module}/julia-1.1.service")}
JULIAUNIT

    cudajulia-path = <<CUDAJULIAPATH
${file("${path.module}/cudajulia.path")}
CUDAJULIAPATH

    cudajulia-unit = <<CUDAJULIAUNIT
${file("${path.module}/cudajulia.service")}
CUDAJULIAUNIT

    kokkos-build= <<KOKKOSBUILD
${file("${path.module}/buildkokkos.sh")}
KOKKOSBUILD

    kokkos-unit = <<KOKKOSUNIT
${file("${path.module}/kokkos.service")}
KOKKOSUNIT
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  guest_accelerator {
    type = "${var.accelerator_type}"
    count = "${var.accelerator_count}"
  }
}
