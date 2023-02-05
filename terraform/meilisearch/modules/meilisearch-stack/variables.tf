
variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "region" {
  description = "Region e.g europe-west1"
  type        = string
}

variable "stage" {
  description = "environment stage: development, production"
  type        = string
}

variable "instance_name" {
  description = "environment stage: development, production"
  type        = string
}


variable "env_vars" {
  type = list(object({
    value = string
    name  = string
  }))
  description = "Environment variables (cleartext)"
  default     = []
}

