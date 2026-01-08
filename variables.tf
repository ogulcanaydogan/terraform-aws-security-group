variable "name" {
  description = "Name of the security group."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0 && length(var.name) <= 255
    error_message = "name must be between 1 and 255 characters."
  }
}

variable "description" {
  description = "Description of the security group."
  type        = string
  default     = "Managed by Terraform"

  validation {
    condition     = length(var.description) <= 255
    error_message = "description must be 255 characters or less."
  }
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "vpc_id must be a valid VPC ID (e.g., vpc-12345678)."
  }
}

variable "use_name_prefix" {
  description = "Whether to use name_prefix instead of name. Useful for create_before_destroy lifecycle."
  type        = bool
  default     = false
}

variable "ingress_rules" {
  description = "List of ingress rules. Supports cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups, and self."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : rule.from_port >= -1 && rule.from_port <= 65535
    ])
    error_message = "from_port must be between -1 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : rule.to_port >= -1 && rule.to_port <= 65535
    ])
    error_message = "to_port must be between -1 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1", "all"], lower(rule.protocol)) || can(tonumber(rule.protocol))
    ])
    error_message = "protocol must be tcp, udp, icmp, icmpv6, -1, all, or a protocol number."
  }
}

variable "egress_rules" {
  description = "List of egress rules. Supports cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups, and self."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules : rule.from_port >= -1 && rule.from_port <= 65535
    ])
    error_message = "from_port must be between -1 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : rule.to_port >= -1 && rule.to_port <= 65535
    ])
    error_message = "to_port must be between -1 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1", "all"], lower(rule.protocol)) || can(tonumber(rule.protocol))
    ])
    error_message = "protocol must be tcp, udp, icmp, icmpv6, -1, all, or a protocol number."
  }
}

variable "tags" {
  description = "A map of tags to assign to the security group."
  type        = map(string)
  default     = {}
}
