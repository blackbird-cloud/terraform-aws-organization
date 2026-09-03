# AWS Organizations Terraform module
A Terraform module which configures your AWS Organization and creates AWS accounts. Read [this](https://docs.aws.amazon.com/organizations/index.html) page for more information, and for a secure reference architecture by AWS, read [this](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/welcome.html) page.

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://www.blackbird.cloud)

Associates a member account as the AWS Firewall Manager administrator. AWS only accepts this call in `us-east-1`, so pass a provider configured for that region:

```hcl
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "fms_admin" {
  source     = "../modules/fms-admin"
  providers  = { aws = aws.us_east_1 }
  account_id = module.accounts.accounts["network"].id
}
```

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_fms_admin_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fms_admin_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | ID of the member account to associate as the Firewall Manager administrator. The account must already be a delegated administrator for fms.amazonaws.com. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_admin_account"></a> [admin\_account](#output\_admin\_account) | The Firewall Manager administrator account association |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://www.blackbird.cloud)
