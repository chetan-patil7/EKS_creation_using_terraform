output "cluster_endpoint" {
  description = "The endpoint for the EKS Kubernetes API"
  value       = aws_eks_cluster.aws_eks_cluster.endpoint

}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.aws_eks_cluster.name

}
