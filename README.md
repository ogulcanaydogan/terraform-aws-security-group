# terraform-aws-patterns

A collection of Terraform modules for common AWS infrastructure patterns.

## Modules
- **Security Group**: `modules/security-group`
- **ECR Repository**: `modules/ecr-repo`

## Usage
Reference modules directly from the repository using a git source URL.

### Security Group
```hcl
module "security_group" {
  source = "git::https://github.com/ogulcanaydogan/terraform-aws-patterns.git//modules/security-group?ref=v0.1.0"

  name   = "example-security-group"
  vpc_id = "vpc-12345678"

  ingress_rules = [
    {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```

### ECR Repository
```hcl
module "ecr_repo" {
  source = "git::https://github.com/ogulcanaydogan/terraform-aws-patterns.git//modules/ecr-repo?ref=v0.1.0"

  name                     = "example-ecr-repo"
  force_delete             = false
  enable_scan_on_push      = true
  enable_lifecycle_policy  = true
  lifecycle_policy_json    = <<POLICY
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
}
```

## Examples
Each module includes an `examples/basic` configuration that can be initialized and validated:
- `modules/security-group/examples/basic`
- `modules/ecr-repo/examples/basic`
