variable "project" {
  description = "The GCP project ID"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]{4,28}[a-zA-Z0-9])?$", var.project))
    error_message = <<EOF
The project name must be:
    - between 6 and 30 characters long
    - start and end with a letter or number
    - contain only letters, numbers, and hyphens (without consecutive hyphens)
EOF
  }
}

variable "region" {
  description = "The GCP region"
  type        = string
  # should fit the region name patterns
  validation {
    condition     = contains(["us-central1", "us-east1", "us-east4", "us-south1", "us-west1"], var.region)
    error_message = <<EOF
Region must be one of:
    - us-central1
    - us-east1
    - us-east4
    - us-south1
    - us-west1
EOF
  }
}

variable "github_token_secret" {
  description = "The name of the secret that holds the github token"
  type        = string
}

variable "repo" {
  description = <<EOF
The details about the github repo:
    - name:  the short name of the repo
    - owner: the owner of the rep
  EOF
  type = object({
    name  = string
    owner = string
  })
  validation {
    condition     = length(var.repo.name) > 0
    error_message = "The repository name must not be empty."
  }
  validation {
    condition     = length(var.repo.owner) > 0
    error_message = "The repository owner must not be empty."
  }
}

variable "build_file_in_repo" {
  type        = string
  description = "Where in the repo is the cloud build definition file"
}
