variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

}

variable "availability_zones"{
  description = "The availability zones for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private-subnet-cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)

}

variable "public-subnet-cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
