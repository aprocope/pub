###################################################
#VPC Variables
###################################################

variable "vpc_cidr" {
  description = "VPC Cidr string variable"
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "VPC name string variable"
  type        = string
  default     = ""
}

variable "public_subnet_cidr" {
  description = "Public Subnet Cidr List string variable"
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

variable "private_subnet_cidr" {
  description = "Private Subnet Cidr List string variable"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "Availabitility Zone List string variable"
  type        = list(string)
  default     = []
}

###################################################
#ECS Variables
###################################################

variable "cluster_name" {
  description = "Cluster Name string variable"
  type        = string
  default     = ""
}

variable "container_name" {
  description = "Container Name string variable"
  type        = string
  default     = ""
}

variable "container_image" {
  description = "Container Name string variable"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Service Name string variable"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnet List variable"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security Group List variable"
  type        = list(string)
  default     = []
}

###################################################
#Load Balancer Variables
###################################################

variable "lb_name" {
  description = "Load Balancer Name string variable"
  type        = string
  default     = ""
}

variable "tg_name" {
  description = "Target Group Name string variable"
  type        = string
  default     = ""
}

###################################################
#S3 Variables
###################################################

variable "bucket_name" {
  description = "S3 Bucket Name string variable"
  type        = string
  default     = ""
}


###################################################
#Environment Variables
###################################################

variable "env" {
  description = "Environment string variable"
  type        = string
  default     = ""
}