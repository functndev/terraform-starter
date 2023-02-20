# terraform starter

## Terraform

1. install terraform <https://developer.hashicorp.com/terraform/downloads?product_intent=terraform>

### Folder structure

everything terraform related is in the terraform folder. the terraform folder contains the following folders

- {app} e.g frontend
  - inside the app folder there is a folder environments with a subfolder for each env. e.g dev & prod
  - next to the environments folder there is a folder called modules which contains the modules for the app
  - normally we only have one module called {app}-stack but there might be others
  - the environments need to copy the variables folder from the stack folder, this is shortcoming of terraform and not very dry.

### How to setup terraform

1. create a google cloud project if it doesn't exist
2. inside the cloud project go to IAM & Admin -> Service Accounts and create a service account (name it `terraform-deployment` for example) with the owner role
<img width="658" alt="Pasted Graphic 1" src="https://user-images.githubusercontent.com/58791244/220123451-7721417c-c446-45da-870c-9af6e2e79781.png">

3. create a key for the service account and download it, place it the environment folder (`environment/*/credentials.json`)
4. create a file `development.tfvars` in the environment folder or copy & paste the sample from 1P

### How to initialize terraform

1. go to the google cloud project and create a bucket for terraform state
2. make sure to update the bucket name in the providers.tf file
3. run 
  ```bash 
    export GOOGLE_CREDENTIALS=credentials.json
  ```
4. go to the environment folder and run 
  ```bash
  terraform init
  ````
### How to deploy the stack for the first time

Google Cloud requires several APIs to be enabled and there seem to be race conditions that even though our terraform stack
includes the activation of these APIs, they are not always activated in time. So you might encounter some errors and have to run the command more than once, I am happy to take suggestions on how to improve this.

To deploy first run
```bash
terraform plan -var-file=development.tfvars
```

and then

```bash
terraform apply -var-file=development.tfvars
```

There will be two errors immediately, just run the apply-command again until you're left with the second one, which should be the Github repository not being found – this has to be added manually on the Triggers page in Cloud Build ("Connect repository"). After you've connected the repository, you can run the apply-command again. When you reload the Triggers page now you should see the trigger there.

The next error will be that the Cloud Run Service needs the Docker image to be present and this will only be the case
after the cloud build trigger has run for the first time – so you'll have to manually run the trigger from the Triggers page once terraform created it (first make sure that you have the permissions enabled, see screenshot). This step will also automatically create a Cloud Run Service.
<img width="640" alt="Pasted Graphic 2" src="https://user-images.githubusercontent.com/58791244/220125929-34f1c73d-e699-4875-82c8-7e2ea593e091.png">

Now when you run the apply-command once again there should be no errors – the only message in red should be that the Cloud Run Service has to be replaced, but that's fine because we want to replace the automatically generated one from the previous step.

### environment variables & secrets

#### environment variables

these can be defined in the terraform.tfvars file and are used to configure the application, we should not add them manually

#### secrets

secrets need to be added to the stack. e.g we are actually using a secret to store the name of the cloud build trigger (thats a hack, but it works). so you can see the cloudbuild.tf file on how to create a secret.
