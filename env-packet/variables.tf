variable "auth_token" {
  description = "Packet Host API token"
}

variable "project_id" {
  default     = null
  description = "Project ID to deploy instances into (if not specified, one will be created)"
}

variable "instance_count" {
  default     = 0
  description = "Number of JMeter instances to provision (set non-zero value to create instances)"
}
