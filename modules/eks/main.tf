resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}


resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}


resource "aws_eks_cluster" "aws_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
	subnet_ids = var.subnet_ids
	vpc_id     = var.vpc_id
  }

  version = var.cluster_version
  depends_on = [ aws_iam_role_policy_attachment.cluster_policy ]

}


resource "aws_iam_role" "node" {
	name = "${var.cluster_name}-node-role"
	assume_role_policy = jsondecode({
		Version = "2012-10-17"
		Statement = [{
			Action = "sts:AssumeRole"
			Effect = "Allow"
			Principal = {
				Service = "ec2.amazonaws.com"
			}
		}]
	})

}


resource "aws_iam_role_policy_attachment" "node_policy" {
	for_each = toset([
		"arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
		"arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
		"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
	])
	role       = aws_iam_role.node.name
	policy_arn = each.value
}


resource "aws_eks_node_group" "ec2_grp" {
	for_each = var.node_groups

	cluster_name    = aws_eks_cluster.aws_eks_cluster.name
	node_group_name = each.key
	node_role_arn   = aws_iam_role.node.arn
	subnet_ids      = var.subnet_ids

	instance_types = each.value.instance_type
	capacity_type = each.value.capacity_type

	scaling_config {
	  desired_size = each.value.scaling_config.desired_size
	  max_size     = each.value.scaling_config.max_size
	  min_size     = each.value.scaling_config.min_size
	}
	depends_on = [ aws_iam_role_policy_attachment.node_policy ]

}
