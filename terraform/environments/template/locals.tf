# This file should hold all of the info needed to create your Cloud Build.
# Fill in all of the blanks with your details.

locals {
  # *GCP info*
  project_id = "" # The ID of the project (not the name)
  region     = "" # The region to use for the Google providers
  zone       = "" # The zone to use for the Google providers

  # *infrastructure config*
  repo_name                = "" # The github repo name, eg. github-cloud-build-poc
  repo_owner               = "" # The owner of the repo, eg. choatej
  build_file_in_repo       = "" # The path in the repo to the Cloud Build definition file
  github_token_secret_name = "" # The name of the secret in Google Secret Manager
}
