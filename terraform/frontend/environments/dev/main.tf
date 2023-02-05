module "frontend-stack" {

    source = "../../modules/frontend-stack"
 
    stage = var.stage
    branch = var.branch
    project_id = var.project_id
    service_name = var.service_name
    location = var.location
    gcr_hostname = var.gcr_hostname
    repo = var.repo
    allow_public_access = var.allow_public_access
    repo_owner =var.repo_owner
    verified_domain_name = var.verified_domain_name
    env_vars = var.env_vars
    
}