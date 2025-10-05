provider "aws" {
    region                   = var.aws_region
    shared_credentials_files = var.shared_credentials_files
    profile                  = var.profile
}
