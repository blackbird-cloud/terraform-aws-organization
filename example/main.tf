module "organization" {
  source  = "blackbird-cloud/organization/aws"
  version = "~> 2"

  aws_service_access_principals = [
    "sso.amazonaws.com",
    "backup.amazonaws.com",
    "securityhub.amazonaws.com",
    "guardduty.amazonaws.com",
    "inspector2.amazonaws.com",
    "aws-artifact-account-sync.amazonaws.com",
    "health.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "ram.amazonaws.com",
    "reporting.trustedadvisor.amazonaws.com",
    "servicequotas.amazonaws.com",
    "account.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "malware-protection.guardduty.amazonaws.com"
  ]
  feature_set = "ALL"
  organizational_units = [
    {
      name     = "workloads"
      accounts = []
      tags     = {}
      organizational_units = [
        {
          name                 = "develop"
          organizational_units = []
          accounts             = []
          tags                 = {}
        },
        {
          name                 = "production"
          organizational_units = []
          accounts             = []
          tags                 = {}
        }
      ],
    },
    {
      name                 = "infrastructure"
      organizational_units = []
      tags                 = {}
      accounts = [
        {
          name                             = "monitoring"
          email                            = "info+monitoring@website.com"
          delegated_administrator_services = []
        },
      ]
    },
    {
      name                 = "networking"
      organizational_units = []
      tags                 = {}
      accounts = [
        {
          name                             = "networking"
          email                            = "info+networking@website.com"
          delegated_administrator_services = []
        },
      ]
    },
    {
      name                 = "security"
      organizational_units = []
      tags                 = {}
      accounts = [
        {
          name  = "tools"
          email = "info+security-tools@website.com"
          delegated_administrator_services = [
            "config.amazonaws.com",
            "guardduty.amazonaws.com",
            "inspector2.amazonaws.com",
            "securityhub.amazonaws.com",
            "config-multiaccountsetup.amazonaws.com"
          ]
        },
        {
          name                             = "logs"
          email                            = "info+security-logs@website.com"
          delegated_administrator_services = ["backup.amazonaws.com"]
        }
      ]
    },
  ]

  organizations_policies = {}
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html

  primary_contact = {
    address_line_1  = "My address"
    address_line_2  = "My office unit"
    city            = "Amsterdam"
    company_name    = "My company"
    country_code    = "NL"
    postal_code     = "1234AB"
    state_or_region = "Noord-Holland"
    phone_number    = "+316XXXXXXXX"
    website_url     = "https://www.website.com"
    full_name       = "Jane Doe"
  }

  billing_contact = {
    name          = "Jane Doe"
    title         = "Co-founder"
    email_address = "info@website.com"
    phone_number  = "+316XXXXXXXX"
  }

  security_contact = {
    name          = "Jane Doe"
    title         = "Co-founder"
    email_address = "info@website.com"
    phone_number  = "+316XXXXXXXX"
  }

  operations_contact = {
    name          = "Jane Doe"
    title         = "Co-founder"
    email_address = "info@website.com"
    phone_number  = "+316XXXXXXXX"
  }
}
