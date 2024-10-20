# More Than Certified GitOps 2024 Minicamp Terraform documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9.0 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.69.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.69.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_default_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/default_security_group) | resource |
| [aws_internet_gateway.gitops_igw](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/internet_gateway) | resource |
| [aws_route_table.gitops_rt](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/route_table) | resource |
| [aws_route_table_association.gitops_rta](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/route_table_association) | resource |
| [aws_subnet.gitops_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/subnet) | resource |
| [aws_vpc.gitops_vpc](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/data-sources/caller_identity) | data source |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/5.69.0/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | (Required) Name of the project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | (Required) Name of the AWS region resources will be deployed into. | `string` | n/a | yes |
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | (Required) A valid CIDR block to assign to the Grafana Server subnet | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | (Required) A valid CIDR block to assign to the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_account_id"></a> [aws\_account\_id](#output\_aws\_account\_id) | AWS account number resources are deployed into |
| <a name="output_default_tags"></a> [default\_tags](#output\_default\_tags) | A map of default tags applied to resources. |
<!-- END_TF_DOCS -->
