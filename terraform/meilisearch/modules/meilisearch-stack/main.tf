locals {
  instance_name = format("%s-%s", var.instance_name, var.stage)
  zone = "${var.region}-b"
  env_variables = [for var_name, var_value in var.env_vars : {
    name = var_name
    value = var_value
  }]
}

variable "gcp_service_list" {
  description ="The list of apis necessary for the project"
  type = list(string)
  default = [
    "compute.googleapis.com"
  ]
}

resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project = var.project_id
  service = each.key
}


resource "google_compute_instance" "vm" {
  project = var.project_id
  zone = local.zone
  name = local.instance_name

  machine_type = "f1-micro"
 
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "XXX-set-image" // TODO: actually create image as TF Construct
    }
  }

  network_interface {
    network = "default"
    
    access_config {}
  }

  tags = ["http-server","https-server"]

#   service_account {
#     email = var.client_email
#     scopes = [
#       "https://www.googleapis.com/auth/cloud-platform",
#     ]
#   } // TODO: create service account for compute instance
}

