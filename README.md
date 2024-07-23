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
- [Testing](#testing)
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

## Testing

### Testing the Triggers
To test the Cloud Build configration, you should perform a push to a branch on the repo to ensure the Cloud Build
triggers as expected.  Next, you should create a PR and ensure that both triggers the build and that the build logs
are written to the PR.

If the build configuration file can not be found on your branch, the build will fail to start.  You should be able to look
in Google Logging for something like:  
`ERROR: (gcloud.builds.submit) HTTPError 400: no build steps were provided; either provide a configuration file or list of steps in the request.`

### Testing the Build Config
While testing the builds themselves are orthogonal to this project, here are some tips on how you can test them.

**Run a Cloud Build Locally**

*Local Builder* allows you to run Cloud Builds on your local machine using both `gcloud` and `docker`.
While Google has archived its version of [Cloud Build Local](https://github.com/GoogleCloudPlatform/cloud-build-local),
there is a [community fork](https://github.com/chriseaton/cloud-build-local) that is still currently maintained.  
It is still as-is so it may not work perfectly. Directions can be found in the project's README.

**Other Possibilities**

There are rumors that you may be able to use Tekton to test cloud builds, but this requires more exploration.
Other than that you just need to run the builds and see what happens.
One strategy would be to abstract the steps from the Cloud Build and then run them locally.

## Contributing
See [CONTRIBUTING](CONTRIBUTING.md)

## License
See [LICENSE](LICENSE)
