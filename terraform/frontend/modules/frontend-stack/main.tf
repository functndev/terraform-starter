
locals {
  template_annotations     = var.template_annotations
  service_name = "${var.service_name}-${var.stage}"
  image = "${var.gcr_hostname}/${var.project_id}/${var.repo}/${var.service_name}-${var.stage}:latest"
}

variable "gcp_service_list" {
  description ="The list of apis necessary for the project"
  type = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}

resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project = var.project_id
  service = each.key
}

resource "google_cloud_run_service" "frontend" {
  provider                   = google-beta
  name                       = local.service_name
  location                   = var.location
  project                    = var.project_id
  autogenerate_revision_name = true
  template {
    spec {
      containers {
        image   = local.image

        ports {
          name           = var.ports["name"]
          container_port = var.ports["port"]
        }

        resources {
          limits   = var.limits
          requests = var.requests
        }
        
        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.value["name"]
            value = env.value["value"]
          }
        }

        dynamic "env" {
          for_each = var.env_secret_vars
          content {
            name = env.value["name"]
            dynamic "value_from" {
              for_each = env.value.value_from
              content {
                secret_key_ref {
                  name = value_from.value.secret_key_ref["name"]
                  key  = value_from.value.secret_key_ref["key"]
                }
              }
            }
          }
        }
      }                                               
      container_concurrency = var.container_concurrency 
      timeout_seconds       = var.timeout_seconds          
    } 
    metadata {
      labels      = var.template_labels
      annotations = var.template_annotations
    } 
  } 
  dynamic "traffic" {
    for_each = var.traffic_split
    content {
      percent         = lookup(traffic.value, "percent", 100)
      latest_revision = lookup(traffic.value, "latest_revision", null)
      revision_name   = lookup(traffic.value, "latest_revision") ? null : lookup(traffic.value, "revision_name")
    }
  }
  
}

resource google_cloud_run_service_iam_member public_access {
  count = var.allow_public_access ? 1 : 0
  service = google_cloud_run_service.frontend.name
  location = google_cloud_run_service.frontend.location
  project = google_cloud_run_service.frontend.project
  role = "roles/run.invoker"
  member = "allUsers"
}


resource "google_cloud_run_domain_mapping" "domain_map" {
  for_each = toset(var.verified_domain_name)
  provider = google-beta
  location = google_cloud_run_service.frontend.location
  name     = each.value
  project  = google_cloud_run_service.frontend.project

  metadata {
    namespace   = var.project_id
  }

  spec {
    route_name       = google_cloud_run_service.frontend.name
    force_override   = var.force_override
    certificate_mode = var.certificate_mode
  }
  depends_on = [
    google_cloud_run_service.frontend
  ]
}