# Terraform GCP Cloud Build Setup

This project is a POC of using Terraform to create GCP infrastructure for Cloud Build triggers linked to GitHub
repositories.

## Table of Contents

- [Overview](#Overview)
- [Prerequisites](#prerequisites)
  - [Assumptions](#Assumptions)
  - [Software and Configuration](#software-and-configuration)
  - [Permissions](#permissions)
- [Usage](#usage)
  - [Add a New Cloud Build](#add-a-new-cloud-build)
    - [Run Terraform Commands](#apply-the-terraform-and-set-up-the-new-cloud-build)
  - [Remove a Cloud Build](#remove-a-cloud-build)
- [Contributing](#contributing)
- [License](#license)

## Overview
The Terraform creates a Cloud Build connection to the specified GitHub repo.  It also creates a 
trigger that will create a build any time commits are pushed to a development branch as signified
by having the prefix `feat-`, `feature-`, `FEAT-`, or `FEATURE`.  This code could be extended 
to allow more control on the creation of one or more triggers.

The build trigger is set to copy the build logs to the repo.
## Prerequisites

### Assumptions
- The build definition is stored in the repository in a specified path.  The trigger
will be configured to use this build definition.
- All resources will be in the same project. The providers are configured 
based on the local variables.  You will need to make several edits if you need to span projects/regions/zones.

### Software and Configuration
- [Terraform](https://www.terraform.io/downloads.html) installed. Version `>= 1.9.2`
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and authenticated.
- Permissions on the target GCP project to create and delete Cloud Build resources, and read from Secret Manager.
- You need to have a GitHub access token stored in Google Secret Manger in the target project, and the entity running
the Terraform will need to be able to read the secret.
- The target project needs to have the Cloud Build API enabled. You can verify if it is either though the [GCP console](console.cloud.google.com/cloud-build)
or through the CLI command `gcloud services list --enabled --project YOUR-PROJECT --filter="NAME=cloudbuild.googleapis.com"`
If its not enabled you can enable it through the UI or run:
 `gcloud services enable --project YOUR-PROJECT cloudbuild.googleapis.com`
 
### Permissions
Your Google Cloud account needs to have the following roles or the equivalent:
- `cloudbuild.builds.editor`
- `serviceusage.serviceUsageConsumer`

If you are using the gcs backend, you will also need:
 - `storage.objectViewer`
 - `storage.objectCreator` 

OR
 - `storage.objectAdmin`

If the bucket is using object-level permissions, you will also need these roles on the bucket itself.


If you want to view the logs in GCP, you will also need the`logging.viewer` role.

## Setup Instructions

### Add a New Cloud Build

1. **Navigate to the `terraform/environments` directory:**

```shell
    cd terraform/environments
```

2. **Copy the template directory:**
 ```shell
cp -r template new-repo-name
```

3. **Navigate to the new directory:**
```shell
cd new-repo-name
```

4. **Fill in the blanks in `locals.tf`:**

Replace placeholder values with actual values for your project. Each field should have a comment describing what is
needed.

5. **Update your backend in `main.tf`:**

update the backend section with your details. It is set to use gcs but you could change it to whatever backend you want.

```shell
  backend "gcs" {
    bucket = "<your bucket here>"
    prefix = "<your bucket folder here>"
  }
```

#### Apply the Terraform and Set up the New Cloud Build
1. **Navigate to your environment directory:**
```shell
cd terraform/environments/new-repo-name
```

2. **Ensure you have the right Terraform version. It should be in a `.terraform-version` file.
```shell
#> cat .terrafom-version
1.9.2
```
You may need to install the version if you do not have it installed already.

Pro-tip: tools like [tfenv](https://github.com/tfutils/tfenv) and [tfswitch](https://github.com/warrensbox/terraform-switcher)
can help you manage multiple Terraform installs.

3. **Initialize your environment:**
```shell
terraform init
```

4. **Run a plan and review what Terraform intends to do:**
```shell
terraform plan
```

5. **Review the plan. If it looks good, apply it:**
```shell
terraform apply
```

> [!CAUTION]
> This Terraform will store the GitHub access token in plain text in the Terraform state so be sure that
your state file and the bucket it is in are properly secured!

### Removing a Cloud Build
Removing a Cloud Build this way will remove the build trigger and the repo connection.
It will not remove the GitHub token from the Secret Manager or any IAM changes that were made since none of those
are managed by this Terraform.

1. **Navigate to your environment directory:**
```shell
cd terraform/environments/new-repo-name
```

2. **Ensure you have the right Terraform version. It should be in a `.terraform-version` file.
```shell
#> cat .terrafom-version
1.9.2
```
You may need to install the version if you do not have it installed already.

Pro-tip: tools like [tfenv](https://github.com/tfutils/tfenv) and [tfswitch](https://github.com/warrensbox/terraform-switcher)
can help you manage multiple Terraform installs.

3. **Initialize your environment:**
```shell
terraform init
```

4. **Run a destroy plan and review what Terraform intends to do:**
```shell
terraform plan -destroy
```

5. **Review the plan. If it looks good, apply it:**
```shell
terraform destroy
```

## Contributing
See [CONTRIBUTING](CONTRIBUTING.md)

## License
See [LICENSE](LICENSE)
