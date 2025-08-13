packer {
  required_plugins {
    oracle-oci = {
      version = ">= 1.0.0"
      source  = "github.com/oracle/oci"
    }
  }
}

variable "compartment_ocid" {
  type = string
}

variable "subnet_ocid" {
  type = string
}

source "oracle-oci" "ubuntu_todo" {
  # Automatically reads credentials from /var/lib/jenkins/.oci/config
  config_file_profile = "DEFAULT"
  config_file         = "/var/lib/jenkins/.oci/config"

  compartment_ocid    = var.compartment_ocid
  availability_domain = "yFYg:AP-HYDERABAD-1-AD-1"
  region              = "ap-hyderabad-1"
  base_image_ocid     = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaaca7s2s5pgnooszcjysi7pknrimayqjds6knvjascphe2r767m6vq"
  shape               = "VM.Standard.E2.1.Micro"
  subnet_ocid         = var.subnet_ocid
  ssh_username        = "ubuntu"
}

build {
  name    = "ubuntu-todo-app"
  sources = ["source.oracle-oci.ubuntu_todo"]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nodejs npm",
      "cd /home/ubuntu/todo-app",
      "npm install",
      "npm run build"
    ]
  }
}
