variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

variable "aws_environment" {
  description = "Environment"
  type        = string
}

variable "aws_project" {
  description = "Project"
  type        = string
}

variable "aws_owner" {
  description = "Owner"
  type        = string
}

variable "aws_vpc_config" {
  description = "VPC configuration"
  type = object({
    cidr_block                   = string,
    enable_dns_support           = bool,
    enable_dns_hostnames         = bool,
    public_subnets_cidr          = list(string),
    private_subnets_cidr         = list(string),
    number_of_availability_zones = number,
    enable_nat_gateway           = bool
  })
}

variable "aws_instance_type" {
  description = "Instance type"
  type        = string
}

variable "aws_eni_ip" {
  description = "ENI IPs"
  type        = string
}

variable "aws_key_name" {
  description = "Key name"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = ""
}

variable "vpn_instance_count" {
  description = "Number of vpn instances"
  type        = number
}

variable "monitoring_frontend_instance_count" {
  description = "Number of monitoring frontend instances"
  type        = number
}

variable "monitoring_backend_instance_count" {
  description = "Number of monitoring backend instances"
  type        = number
}

variable "app_instance_count" {
  description = "Number of app instances"
  type        = number
}

variable "vpn_instance_ebs_size" {
  description = "Size of the EBS volume for the VPN instance"
  type        = number
  default     = 8
}

variable "monitoring_frontend_instance_ebs_size" {
  description = "Size of the EBS volume for the monitoring frontend instance"
  type        = number
  default     = 8
}

variable "monitoring_backend_instance_ebs_size" {
  description = "Size of the EBS volume for the monitoring backend instance"
  type        = number
  default     = 8
}

variable "app_instance_ebs_size" {
  description = "Size of the EBS volume for the app instance"
  type        = number
  default     = 8
}
