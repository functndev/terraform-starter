terraform {
  backend "gcs" {
    bucket  = "terraform-state-piment-meilisearch-dev"
    prefix  = "meilisearch-dev"
  }  
  required_version = ">= 1.3.4"  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.53, < 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.53, < 5.0"
    }
  }
}

provider "google" {
  credentials = file("credentials.json")
  project = "project_id"
  region  = "regione_name"
}