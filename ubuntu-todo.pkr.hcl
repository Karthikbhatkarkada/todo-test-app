packer {
  required_plugins {
    oracle = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/oracle"
    }
  }
}

variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "key_file" {
  type = string
}

variable "availability_domain" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "subnet_ocid" {
  type = string
}

source "oracle-oci" "ubuntu_todo" {
  tenancy_ocid        = var.tenancy_ocid
  user_ocid           = var.user_ocid
  fingerprint         = var.fingerprint
  key_file            = var.key_file
  availability_domain = var.availability_domain
  compartment_ocid    = var.compartment_ocid
  region              = "ap-hyderabad-1"
  subnet_ocid         = var.subnet_ocid

  base_image_ocid     = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaafs7imfvcicboqisaisiz5bbpuzbg5gicwjwvyhnhsvdaowuc3w4q" # Replace with latest Ubuntu OCID
  shape               = "VM.Standard.E2.1.Micro"
  ssh_username        = "ubuntu"
}

# ---------------------------
# Build Block
# ---------------------------
build {
  sources = ["source.oracle-oci.ubuntu_todo"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y curl git",
      # Install NVM, Node.js, and npm
      "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash",
      "export NVM_DIR=\"$HOME/.nvm\"",
      "[ -s \"$NVM_DIR/nvm.sh\" ] && \\. \"$NVM_DIR/nvm.sh\"",
      "nvm install 24",
      "nvm use 24",
      # Clone the ToDo app repo
      "git clone https://github.com/Karthikbhatkarkada/todo-test-app.git /home/ubuntu/todo-app",
      "cd /home/ubuntu/todo-app/app && npm install",
    ]
  }
}
