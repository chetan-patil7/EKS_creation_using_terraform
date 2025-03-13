variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string

}

variable "vpc_id" {
  description = "The VPC ID for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs for the EKS cluster"
  type        = list(string)

}

variable "node_groups" {
	description = "EKS node groups configuration"
	type = map(object({
		instance_type = string
		desired_capacity = number
		max_capacity = number
		min_capacity = number
		scaling_config = object({
		  desired_size = number
		  max_size = number
		  min_size = number
		})
	}))
}
