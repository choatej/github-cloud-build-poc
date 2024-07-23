locals {
  # terraform and provider config
  project_id          = ""
  region              = ""
  zone                = ""
  state_bucket        = ""
  state_bucket_prefix = ""

  # infrastructure config
  repo_name                = ""
  repo_owner               = ""
  build_file_in_repo       = ""
  github_token_secret_name = ""
}
