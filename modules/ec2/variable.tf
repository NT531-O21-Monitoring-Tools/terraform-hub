variable "name" {
  description = "Name of the EC2 instances"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "subnets_id" {
  description = "Subnet ID for the EC2 instances"
  type        = list(string)
  default     = []
}

variable "sgs_id" {
  description = "Security Group ID for the EC2 instances"
  type        = list(string)
  default = []
}

variable "key_name" {
  description = "Key pair name for the EC2 instances"
  type        = string
}

variable "eni_ids" {
  description = "ID of the Elastic Network Interface"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data for the EC2 instances"
  type        = string
  default     = ""
}
