module "meilisearch-stack" {

    source = "../../modules/meilisearch-stack"
 
    stage = var.stage
    project_id = var.project_id
    region = var.region
    instance_name = var.instance_name
    env_vars = var.env_vars
  
    
}