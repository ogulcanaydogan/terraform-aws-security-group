# terraform-aws-security-group

Terraform module that creates an AWS Security Group with flexible ingress and egress rules.

## Features

- **Flexible rule sources** - CIDR blocks, IPv6, prefix lists, security groups, and self-referencing
- **Name prefix support** - Optional name_prefix for create_before_destroy lifecycle
- **Comprehensive validation** - Port ranges, protocols, and VPC ID validation
- **Auto-tagging** - Automatically adds Name tag

## Usage

### Basic Example

```hcl
module "web_sg" {
  source = "ogulcanaydogan/security-group/aws"

  name   = "web-server"
  vpc_id = "vpc-12345678"

  ingress_rules = [
    {
      description = "Allow HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
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

  tags = {
    Environment = "production"
  }
}
```

### With Security Group References

```hcl
module "app_sg" {
  source = "ogulcanaydogan/security-group/aws"

  name        = "app-server"
  description = "Application server security group"
  vpc_id      = "vpc-12345678"

  ingress_rules = [
    {
      description     = "Allow from web tier"
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      security_groups = [module.web_sg.id]
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

### With Self-Referencing Rules

```hcl
module "cluster_sg" {
  source = "ogulcanaydogan/security-group/aws"

  name   = "cluster-nodes"
  vpc_id = "vpc-12345678"

  ingress_rules = [
    {
      description = "Allow cluster communication"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      self        = true
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

### With IPv6 Support

```hcl
module "dual_stack_sg" {
  source = "ogulcanaydogan/security-group/aws"

  name   = "dual-stack"
  vpc_id = "vpc-12345678"

  ingress_rules = [
    {
      description      = "Allow HTTPS IPv4"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  egress_rules = [
    {
      description      = "Allow all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}
```

### With Name Prefix (Zero-Downtime Updates)

```hcl
module "sg" {
  source = "ogulcanaydogan/security-group/aws"

  name            = "my-service"
  use_name_prefix = true
  vpc_id          = "vpc-12345678"

  ingress_rules = [
    {
      description = "Allow HTTPS"
      from_port   = 443
      to_port     = 443
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name of the security group | `string` | - | yes |
| `vpc_id` | VPC ID where the security group will be created | `string` | - | yes |
| `description` | Description of the security group | `string` | `"Managed by Terraform"` | no |
| `use_name_prefix` | Use name_prefix instead of name | `bool` | `false` | no |
| `ingress_rules` | List of ingress rules | `list(object)` | `[]` | no |
| `egress_rules` | List of egress rules | `list(object)` | `[]` | no |
| `tags` | Tags to apply to the security group | `map(string)` | `{}` | no |

### Rule Object Structure

```hcl
{
  description      = string           # Required
  from_port        = number           # Required (-1 for all)
  to_port          = number           # Required (-1 for all)
  protocol         = string           # Required (tcp, udp, icmp, -1, or number)
  cidr_blocks      = list(string)     # Optional
  ipv6_cidr_blocks = list(string)     # Optional
  prefix_list_ids  = list(string)     # Optional
  security_groups  = list(string)     # Optional
  self             = bool             # Optional
}
```

## Outputs

| Name | Description |
|------|-------------|
| `id` | ID of the security group |
| `arn` | ARN of the security group |
| `name` | Name of the security group |
| `vpc_id` | VPC ID of the security group |
| `owner_id` | AWS account ID that owns the security group |

## Examples

See [`examples/basic`](./examples/basic) for a working configuration.
