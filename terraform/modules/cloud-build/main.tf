
# This gets save in terraform state in clear text, protect it and rotate it!
data "google_secret_manager_secret_version_access" "github-token-secret" {
  project = var.project
  secret  = var.github_token_secret
}

resource "google_cloudbuildv2_connection" "my-connection" {
  project  = var.project
  location = var.region
  name     = "github-com-${var.repo.owner}-${var.repo.name}"

  github_config {
    authorizer_credential {
      oauth_token_secret_version = data.google_secret_manager_secret_version_access.github-token-secret.secret_data
    }
  }
}

resource "google_cloudbuildv2_repository" "my-repo" {
  project           = var.project
  name              = "${var.repo.name}-${var.repo.owner}-github"
  parent_connection = google_cloudbuildv2_connection.my-connection
  remote_uri        = "https://github.com/${var.repo.owner}/${var.repo.name}.git"
}

resource "google_cloudbuild_trigger" "trigger" {
  project            = var.project
  location           = var.region
  name               = "github-push-trigger-${var.repo.name}"
  description        = "Trigger for GitHub push events for ${var.repo.name}"
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
  filename           = var.build_file_in_repo
  repository_event_config {
    repository = google_cloudbuildv2_repository.my-repo.id
    push {
      branch = "feat(?:ure)?-.*"
    }
    pull_request {
      branch = "main"
    }
  }
  substitutions = {
    _GITHUB_TOKEN = data.google_secret_manager_secret_version_access.github-token-secret.secret_data
  }
}
