variable "name_prefix" {
  type        = string
  description = "Prefix applied to resource names within the tenant"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "name_prefix must be lowercase alphanumeric with hyphens only."
  }
}

variable "tenant_id" {
  type        = string
  description = "PCD tenant ID where resources will be created"
}

variable "external_network_id" {
  type        = string
  description = "ID of the external network for the tenant router to attach to"
}

variable "internal_cidr" {
  type        = string
  description = "CIDR block for the tenant internal subnet"
}

variable "dns_nameservers" {
  type        = list(string)
  description = "DNS nameservers to assign to the tenant subnet"
  default     = ["1.1.1.1", "8.8.8.8"]
}
