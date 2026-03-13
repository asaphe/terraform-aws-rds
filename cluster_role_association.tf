resource "aws_rds_cluster_role_association" "this" {
  count = var.use_rds_cluster_role_association ? length(var.iam_roles) : 0

  db_cluster_identifier = aws_rds_cluster.this.id
  feature_name          = var.feature_name
  role_arn              = var.iam_roles[count.index]
}
