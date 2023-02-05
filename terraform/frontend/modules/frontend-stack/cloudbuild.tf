
locals {
  trigger_name = "trigger-${var.service_name}-${var.stage}"
}

resource "google_cloudbuild_trigger" "frontend_cloud_build_trigger" {
  project     = var.project_id
  name        = local.trigger_name
  description = "Cloud build trigger for ${var.service_name} service"
  disabled    = false
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
  github {
    owner = var.repo_owner
    name  = var.repo
    push {
      branch       = var.branch
      invert_regex = false
    }
  }

  substitutions = {
    _DEPLOY_REGION = var.location
    _GCR_HOSTNAME = "eu.gcr.io"
    _PLATFORM = "managed"
    _SERVICE_NAME = local.service_name
    _TRIGGER_ID_SECRET = google_secret_manager_secret.frontend_build_trigger_id_secret.secret_id
    _STAGE = var.stage
  }
  filename = "terraform/frontend/modules/frontend-stack/cloudbuild.yml"
}


resource "google_secret_manager_secret" "frontend_build_trigger_id_secret" {
  project = var.project_id
  secret_id = "${var.service_name}_build_trigger_id_secret_${var.stage}"

  labels = {
    label = "${var.service_name}_build_trigger_id_secret_${var.stage}"
  }
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "frontend_build_trigger_id_secret_version" {
  secret = google_secret_manager_secret.frontend_build_trigger_id_secret.id

  secret_data = google_cloudbuild_trigger.frontend_cloud_build_trigger.trigger_id

  depends_on = [
    google_secret_manager_secret.frontend_build_trigger_id_secret
  ]
}