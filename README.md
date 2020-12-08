# aws-terraform

Simple AWS compute environment bootstrap via Terraform. Likely to be expanded upon. Meant for educational/training purposes only. 

When run, creates an AWS VPC, IGW, public subnet, private subnets (across two AZs), public and private route tables, private compute instance, and a public bastion instance.

_Note: Requires [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (for `~/.aws/credentials` file creation) and Terraform 0.13 or higher._

## Build & Run Instructions
```
aws configure
git clone git@github.com:bucklander/aws-terraform.git
cd aws-terraform/
terraform plan
terraform apply
```

## Usage
N/A