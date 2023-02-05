
variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "stage" {
  description = "environment stage: dev, prod"
  type        = string
}

variable "branch" {
  description = "deployment branch: main, prod"
  type        = string
}

variable "service_name" {
  description = "The name of the Cloud Run service to create"
  type        = string
}

variable "location" {
  description = "Cloud Run service deployment location"
  type        = string
}

variable "gcr_hostname"{
  description = "hostname of the docker registry"
  type = string
}

variable "repo_owner"{
  description = "owner of github repo for cloud build"
  type = string
}

variable "repo"{
  description = "name of the repo for cloud build"
  type = string
}

variable "traffic_split" {
  type = list(object({
    latest_revision = bool
    percent         = number
    revision_name   = string
  }))
  description = "Managing traffic routing to the service"
  default = [{
    latest_revision = true
    percent         = 100
    revision_name   = "v1-0-0"
  }]
}

variable "template_labels" {
  type        = map(string)
  description = "A set of key/value label pairs to assign to the container metadata"
  default     = {}
}

variable "template_annotations" {
  type        = map(string)
  description = "Annotations to the container metadata including VPC Connector and SQL. See [more details](https://cloud.google.com/run/docs/reference/rpc/google.cloud.run.v1#revisiontemplate)"
  default = {
    "run.googleapis.com/client-name"   = "terraform"
    "generated-by"                     = "terraform"
    "autoscaling.knative.dev/maxScale" = 2
    "autoscaling.knative.dev/minScale" = 1
  }
}

variable "container_concurrency" {
  type        = number
  description = "Concurrent request limits to the service"
  default     = null
}

variable "timeout_seconds" {
  type        = number
  description = "Timeout for each request"
  default     = 120
}

variable "limits" {
  type        = map(string)
  description = "Resource limits to the container"
  default     = null
}
variable "requests" {
  type        = map(string)
  description = "Resource requests to the container"
  default     = {}
}

variable "ports" {
  type = object({
    name = string
    port = number
  })
  description = "Port which the container listens to (http1 or h2c)"
  default = {
    name = "http1"
    port = 8080
  }
}

variable "env_vars" {
  type = list(object({
    value = string
    name  = string
  }))
  description = "Environment variables (cleartext)"
  default     = []
}

variable "env_secret_vars" {
  type = list(object({
    name = string
    value_from = set(object({
      secret_key_ref = map(string)
    }))
  }))
  description = "[Beta] Environment variables (Secret Manager)"
  default     = []
}

// Domain Mapping
variable "verified_domain_name" {
  type        = list(string)
  description = "List of Custom Domain Name"
  default     = []
}

variable "force_override" {
  type        = bool
  description = "Option to force override existing mapping"
  default     = false
}

variable "certificate_mode" {
  type        = string
  description = "The mode of the certificate (NONE or AUTOMATIC)"
  default     = "AUTOMATIC"
}

variable "domain_map_labels" {
  type        = map(string)
  description = "A set of key/value label pairs to assign to the Domain mapping"
  default     = {}
}

variable "domain_map_annotations" {
  type        = map(string)
  description = "Annotations to the domain map"
  default     = {}
}

variable "allow_public_access" {
  type        = bool
  description = "Allow public traffic"
  default     = false
}