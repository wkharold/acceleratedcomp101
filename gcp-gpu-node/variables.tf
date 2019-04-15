variable "project" {
  description = "Cloud Platform project that hosts the notebook server(s)"
}

variable "network" {
  description = "Compute Platform network the notebook server will be connected to"
  default = "default"
}

variable "region" {
  description = "Compute Platform region where the notebook server will be located"
  default = "us-central1"
}

variable "zone" {
  description = "Compute Platform zone where the notebook server will be located"
  default = "us-central1-b"
}

variable "node_name" {
  description = "Name of the GPU node"
}

variable "accelerator_type" {
  description = "GPU type to attach to the node"
}

variable "accelerator_count" {
  description = "The number of GPUs to attach to the node"
  default = 1
}

variable "machine_type" {
  description = "Compute Platform machine type to use in node creation"
  default = "n1-standard-8"
}
