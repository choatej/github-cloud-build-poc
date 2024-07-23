terraform {
  required_version = "~> 1.9.2"
  required_providers {
    google = {
      version = "~> 5.38.0"
    }
    google-beta = {
      version = "~> 5.38.0"
    }
  }
  # update the backend with your desired backend config
  backend "gcs" {
    bucket = "<your bucket here>"
    prefix = "<your bucket folder here>"
  }
}

module "cloud-build" {
  source              = "../../modules/cloud-build"
  project             = local.project_id
  region              = local.region
  github_token_secret = local.github_token_secret_name
  repo = {
    name  = local.repo_name
    owner = local.repo_owner
  }
  build_file_in_repo = ""
}
