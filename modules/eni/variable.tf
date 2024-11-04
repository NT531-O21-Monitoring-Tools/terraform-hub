variable "name" {
  description = "Name of the Elastic Network Interface"
  type        = string
}

variable "eni_count" {
  description = "Number of Elastic Network Interfaces"
  type        = number
}

variable "subnet_id" {
  description = "Subnet ID of the route table"
  type        = string
}

variable "private_ips" {
  description = "Private IP addresses for the private EC2 instance"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Group IDs for the ENI"
  type        = list(string)
}
