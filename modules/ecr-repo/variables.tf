variable "name" {
  description = "Name of the ECR repository."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the repository."
  type        = map(string)
  default     = {}
}

variable "force_delete" {
  description = "If true, allows the repository to be deleted even if it contains images."
  type        = bool
  default     = false
}

variable "enable_scan_on_push" {
  description = "Enable image scanning on push."
  type        = bool
  default     = true
}

variable "enable_lifecycle_policy" {
  description = "Enable lifecycle policy for the repository."
  type        = bool
  default     = false
}

variable "lifecycle_policy_json" {
  description = "Lifecycle policy JSON content applied when lifecycle policies are enabled."
  type        = string
  default     = ""

  validation {
    condition     = var.enable_lifecycle_policy == false || trim(var.lifecycle_policy_json) != ""
    error_message = "lifecycle_policy_json must be provided when enable_lifecycle_policy is true."
  }
}
