packer {
  required_plugins {
    oracle = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/oracle"
    }
  }
}

variable "compartment_ocid" {}
variable "subnet_ocid" {}
variable "ssh_username" {
  default = "ubuntu"
}
variable "availability_domain" {}
variable "key_file" {}
variable "fingerprint" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}

source "oracle-oci" "ubuntu" {
  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain
  base_image_ocid     = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaaca7s2s5pgnooszcjysi7pknrimayqjds6knvjascphe2r767m6vq"
  shape               = "VM.Standard.E2.1.Micro"
  subnet_ocid         = var.subnet_ocid
  ssh_username        = var.ssh_username

  # OCI API authentication
  key_file     = var.key_file
  fingerprint  = var.fingerprint
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
}

build {
  name    = "ubuntu-todo-image"
  sources = ["source.oracle-oci.ubuntu"]

  provisioner "shell" {
    script = "scripts/install_dependencies.sh"
  }

  provisioner "file" {
    source      = "../app/"
    destination = "/home/ubuntu/todo-app"
  }

  provisioner "shell" {
    script = "scripts/install_app.sh"
  }
}
