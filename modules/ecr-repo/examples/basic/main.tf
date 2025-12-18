provider "aws" {
  region = "us-east-1"
}

module "ecr_repo" {
  source = "../.."

  name                = "example-ecr-repo"
  force_delete        = false
  enable_scan_on_push = true
  enable_lifecycle_policy = true

  lifecycle_policy_json = <<POLICY
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
POLICY

  tags = {
    Environment = "example"
    ManagedBy   = "terraform"
  }
}
