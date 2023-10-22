variable "vpc_name" {
  description = "VPC name string variable"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Service name string variable"
  type        = string
  default     = ""
}

variable "container_name" {
  description = "Container name string variable"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Cluster name string variable"
  type        = string
  default     = ""
}

variable "lb_name" {
  description = "LB name string variable"
  type        = string
  default     = ""
}

variable "tg_name" {
  description = "TG name string variable"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Bucket name string variable"
  type        = string
  default     = ""
}

variable "env" {
  description = "Env name string variable"
  type        = string
  default     = ""
}

variable "azs" {
  description = "Availabitility Zone List string variable"
  type        = list(string)
  default     = []
}

variable "public_subnet_names" {
  description = "Public Subnet Names List string variable"
  type        = list(string)
  default     = []
}

variable "private_subnet_names" {
  description = "Private Subnet Names List string variable"
  type        = list(string)
  default     = []
}