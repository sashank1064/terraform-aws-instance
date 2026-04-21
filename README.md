# terraform-aws-instance

A reusable Terraform module for creating an AWS EC2 instance with input validation, sensible defaults, and outputs wired up for downstream modules to consume.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)
![HCL](https://img.shields.io/badge/HCL-844FBA?logo=terraform&logoColor=white)

## Overview

The EC2 building block for the RoboShop platform. Every application service (catalogue, user, cart, shipping, payment, dispatch, web) and every data-tier host (mongodb, redis, mysql, rabbitmq) is an instance of this module.

```hcl
module "catalogue" {
  source = "git::https://github.com/sashank1064/terraform-aws-instance.git?ref=main"

  ami_id        = data.aws_ami.devops_practice.id
  instance_type = "t3.small"
  sg_ids        = [data.aws_security_group.catalogue.id]

  tags = {
    Name        = "${var.project}-${var.environment}-catalogue"
    Component   = "catalogue"
    Environment = var.environment
  }
}
```

## What it creates

- `aws_instance` with AMI, instance type, and SG attachments driven by inputs
- Tags are required, so nothing lands untagged on AWS

## Inputs

| Name | Type | Required | Default | Notes |
|---|---|---|---|---|
| `ami_id` | `string` | no | DevOps-Practice AMI ID | Override in consumers; default is a convenience for the sandbox |
| `instance_type` | `string` | no | `t3.micro` | Validated against `t3.micro`, `t3.small`, `t3.medium` |
| `sg_ids` | `list(string)` | yes | `[]` | Security groups to attach |
| `tags` | `map` | yes | n/a | Must include at least `Name`. Typically also `Component`, `Environment`, `Project` |

### Input validation

`instance_type` uses a `validation {}` block that rejects anything outside the allowed list at `plan` time:

```hcl
validation {
  condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
  error_message = "Invalid instance type. Please choose from t3.micro, t3.small, or t3.medium."
}
```

This stops an oversized `m5.4xlarge` from slipping into dev during a rushed merge.

## Outputs

- `public_ip`
- `private_ip`
- `instance_id`

Downstream modules (ALB target group attachment, Route 53 A records, Ansible dynamic inventory) consume these.

## Design notes

- **Tags are required.** No "we'll tag it later." Cost attribution and Ansible-pull targeting both depend on them.
- **No key pair, no user data.** Bootstrap is handled in the consumer (see `terraform-aws-roboshop` for the `user_data` pattern with `ansible-pull`).
- **Pinned provider lock.** `.terraform.lock.hcl` is committed so every consumer resolves the same AWS provider version.

## Used by

- [`terraform-aws-roboshop`](https://github.com/sashank1064/terraform-aws-roboshop) for every application component instance
- [`roboshop-infra-dev`](https://github.com/sashank1064/roboshop-infra-dev) phases `20-bastion`, `30-vpn`, `40-databases`, `60-*`, `80-user`

## Related modules

1. [`terraform-aws-vpc`](https://github.com/sashank1064/terraform-aws-vpc)
2. [`terraform-aws-securitygroup`](https://github.com/sashank1064/terraform-aws-securitygroup)
3. `terraform-aws-instance` (this repo)
