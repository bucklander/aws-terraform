# aws-terraform

Simple AWS compute environment Terraform boilerplate template. Meant to demonstrate ease of Terraform AWS resource provisioning/de-provisioning via IaC, for educational/training purposes only. 

When run, creates an AWS VPC, IGW, public subnet, private subnets (across two AZs), public and private route tables, private compute instance, nat gw, alb, and a public bastion instance. Easily expandable to add additional resources.

_Note: Requires [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (for `~/.aws/credentials` file creation) and Terraform 0.13 or higher._

## Build & Run Instructions
```
aws configure
git clone git@github.com:bucklander/aws-terraform.git
cd aws-terraform/us-west-2/
terraform plan
terraform apply
```

## Usage
N/A