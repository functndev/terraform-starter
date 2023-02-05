# terraform starter

## Terraform

1.) install terraform <https://developer.hashicorp.com/terraform/downloads?product_intent=terraform>

### folder structure

everything terraform related is in the terraform folder. the terraform folder contains the following folders

- {app} e.g frontend
  - inside the app folder there is a folder environments with a subfolder for each env. e.g dev & prod
  - next to the environments folder there is a folder called modules which contains the modules for the app
  - normally we only have one module called {app}-stack but there might be others
  - the environments need to copy the variables folder from the stack folder, this is shortcoming of terraform and not very dry.

### how to setup terraform

1.) create a google cloud project if it doesn't exist
2.) inside the cloud project go to IAM & Admin -> Service Accounts and create a service account with the owner role
3.) create a key for the service account and download it, place it the environment folder
4.) create a file development.tfvars in the environment folder or copy & paste the sample from 1P

### how to initialize terraform

1.) go to the google cloud project and create a bucket for terraform state
2.) make sure to update the bucket name in the providers.tf file
3.) run ``èxport GOOGLE_CREDENTIALS=credentials.json```
4.) go to the environment folder and run terraform init

### how to deploy the stack for the first time

google cloud requires serval apis to be enabled and there seem to be race conditions that even though our terraform stack
includes the activation of these apis, they are not always activated in time. so you might have to run the command more than once
I am happy to take suggestions on how to improve this

to deploy first run the `terraform plan -var-file=development.tfvars` command and then the `terraform apply -var-file=development.tfvars` command

another gotcha which I could not solve yet is that the cloud run service need to docker image to be present and this will pnly be the case
after the cloud build trigger has run for the first time. so once terraform created the cloud build trigger you need to run the build manually
and then run the terraform apply command again. again I am happy for inputs on how to improve this

### environment variables & secrets

#### environment variables

these can be defined in the terraform.tfvars file and are used to configure the application, we should not add them manually

#### secrets

secrets need to be added to the stack. e.g we are actually using a secret to store the name of the cloud build trigger (thats a hack, but it works). so you can see the cloudbuild.tf file on how to create a secret.
