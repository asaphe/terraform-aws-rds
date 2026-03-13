# terraform-aws-rds

A Terraform module for creating Aurora RDS clusters with writer/reader instances, optional parameter groups, IAM role association, and automated password management.

## Features

- Aurora MySQL and Aurora PostgreSQL support
- Configurable writer and reader replica counts
- Automatic master password generation (or user-provided)
- IAM database authentication support
- DB parameter groups with custom parameters
- Performance Insights support
- Enhanced monitoring support
- CloudWatch log exports
- Encryption at rest with optional KMS key
- Deletion protection enabled by default
- IAM role association (inline or via separate resource)

## Usage

### Basic Aurora PostgreSQL Cluster

```hcl
module "rds" {
  source = "github.com/asaphe/terraform-aws-rds?ref=v1.0.0"

  name   = "my-app-db"
  engine = "aurora-postgresql"

  engine_version         = "15.4"
  instance_type          = "db.r6g.large"
  subnet_ids             = ["subnet-abc123", "subnet-def456"]
  vpc_security_group_ids = ["sg-12345678"]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### With Read Replicas

```hcl
module "rds" {
  source = "github.com/asaphe/terraform-aws-rds?ref=v1.0.0"

  name                  = "my-app-db"
  engine                = "aurora-postgresql"
  engine_version        = "15.4"
  instance_type         = "db.r6g.large"
  instance_type_replica = "db.r6g.medium"
  reader_replica_count  = 2

  subnet_ids             = ["subnet-abc123", "subnet-def456"]
  vpc_security_group_ids = ["sg-12345678"]

  tags = {
    Environment = "production"
  }
}
```

### With User-Provided Password

```hcl
module "rds" {
  source = "github.com/asaphe/terraform-aws-rds?ref=v1.0.0"

  name   = "my-app-db"
  engine = "aurora-postgresql"

  create_master_password = false
  user_master_password   = var.db_password

  instance_type          = "db.r6g.large"
  subnet_ids             = ["subnet-abc123", "subnet-def456"]
  vpc_security_group_ids = ["sg-12345678"]
}
```

### With IAM Authentication

```hcl
module "rds" {
  source = "github.com/asaphe/terraform-aws-rds?ref=v1.0.0"

  name   = "my-app-db"
  engine = "aurora-postgresql"

  iam_database_authentication_enabled = true

  instance_type          = "db.r6g.large"
  subnet_ids             = ["subnet-abc123", "subnet-def456"]
  vpc_security_group_ids = ["sg-12345678"]
}
```

### With Custom Parameters

```hcl
module "rds" {
  source = "github.com/asaphe/terraform-aws-rds?ref=v1.0.0"

  name   = "my-app-db"
  engine = "aurora-postgresql"

  parameter_group_family = "aurora-postgresql15"
  parameters = [
    {
      name  = "shared_preload_libraries"
      value = "pg_stat_statements"
    },
    {
      name         = "log_min_duration_statement"
      value        = "1000"
      apply_method = "immediate"
    }
  ]

  instance_type          = "db.r6g.large"
  subnet_ids             = ["subnet-abc123", "subnet-def456"]
  vpc_security_group_ids = ["sg-12345678"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| aws | >= 5.0 |
| random | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name prefix for cluster and associated resources | `string` | - | yes |
| engine | Database engine (e.g., aurora-mysql, aurora-postgresql) | `string` | - | yes |
| instance_type | Instance class for the primary instances | `string` | - | yes |
| subnet_ids | List of subnet IDs for the DB subnet group | `list(string)` | - | yes |
| vpc_security_group_ids | List of VPC security group IDs | `list(string)` | - | yes |
| engine_version | Engine version (auto-detected if null) | `string` | `null` | no |
| engine_mode | Engine mode (provisioned, serverless) | `string` | `null` | no |
| instance_type_replica | Instance class for read replicas | `string` | `null` | no |
| writer_replica_count | Number of writer instances | `number` | `1` | no |
| reader_replica_count | Number of reader replica instances | `number` | `0` | no |
| database_name | Name of the initial database | `string` | `null` | no |
| username | Master username | `string` | `"admin"` | no |
| create_master_password | Whether to generate a random master password | `bool` | `true` | no |
| user_master_password | User-provided master password | `string` | `null` | no |
| iam_database_authentication_enabled | Enable IAM database authentication | `bool` | `false` | no |
| storage_encrypted | Enable storage encryption | `bool` | `true` | no |
| kms_key_id | ARN of the KMS key for encryption | `string` | `null` | no |
| deletion_protection | Enable deletion protection | `bool` | `true` | no |
| backup_retention_period | Number of days to retain backups | `number` | `7` | no |
| skip_final_snapshot | Skip final snapshot on deletion | `bool` | `true` | no |
| apply_immediately | Apply modifications immediately | `bool` | `false` | no |
| monitoring_interval | Enhanced monitoring interval in seconds (0 to disable) | `number` | `0` | no |
| monitoring_role_arn | IAM role ARN for enhanced monitoring | `string` | `""` | no |
| performance_insights_enabled | Enable Performance Insights | `bool` | `false` | no |
| parameter_group_family | DB parameter group family | `string` | `null` | no |
| parameters | List of DB parameter group parameters | `list(object)` | `[]` | no |
| iam_roles | IAM role ARNs to associate with the cluster | `list(string)` | `[]` | no |
| use_rds_cluster_role_association | Use separate role association resource | `bool` | `false` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_arn | ARN of the RDS cluster |
| cluster_id | ID of the RDS cluster |
| cluster_resource_id | Resource ID for IAM policies |
| cluster_endpoint | Primary writer endpoint |
| cluster_reader_endpoint | Reader endpoint |
| cluster_engine_version | Engine version |
| cluster_database_name | Initial database name |
| cluster_master_password | Master password (sensitive) |
| cluster_master_username | Master username (sensitive) |
| cluster_port | Connection port |
| cluster_hosted_zone_id | Route53 hosted zone ID |
| cluster_instance_endpoints | List of instance endpoints |
| cluster_instance_ids | List of instance IDs |
| cluster_instance_dbi_resource_ids | List of DBI resource IDs |
| security_group_id | VPC security group IDs |

## Resources Created

| Resource | File | Description |
|----------|------|-------------|
| `aws_rds_cluster` | main.tf | The Aurora RDS cluster |
| `aws_rds_cluster_instance` | cluster_instance.tf | Writer and reader instances |
| `aws_db_subnet_group` | db_subnet_group.tf | DB subnet group |
| `aws_db_parameter_group` | db_parameter_group.tf | Parameter group (conditional) |
| `aws_rds_cluster_role_association` | cluster_role_association.tf | IAM role association (conditional) |
| `random_password` | random.tf | Auto-generated master password (conditional) |

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.
