variable "location" {
  type        = "string"
  description = "(Optional) Azure location to use"
  default     = "eastus"
}

variable "client_secret" {
  type        = "string"
  description = "(Required) Client Secret for k8s"
}

variable "client_id" {
  type        = "string"
  description = "(Required) Client ID for k8s"
}

variable "key_data" {
  type        = "string"
  description = "(Required) Key_data for k8s"
}
