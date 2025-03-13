output "cluster_name" {
  value = aws_eks_cluster.cluster.name

}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint

}

output "vpc_id" {
	value = module.vpc.vpc_id

}
