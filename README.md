 # CaaCviaGithubActions Lab
Conditional Access as Code with Terraform and GitHub Actions
This project demonstrates how to implement Conditional Access Policies as Code using:

Terraform
Azure Active Directory (Microsoft Entra)
GitHub Actions for CI/CD

The goal is to automate the deployment of Conditional Access policies in a secure, repeatable, and auditable way using Infrastructure as Code (IaC).

🚀 Use Case: Block Non-Compliant Devices from Untrusted Locations
This use case creates a Conditional Access policy that:

»»» Applies to all users, excluding guests and external users.
»»» Applies when sign-in risk is medium or high.
»»» Blocks access from devices not compliant with organizational policy.
»»» Excludes access from trusted locations.
»»» Requires Multi-Factor Authentication (MFA).
»»» Includes session control configurations.

🔧 Tech Stack
Tool	Purpose
Terraform	IaC for Azure resources
AzureAD Provider	Provision Conditional Access policies
GitHub Actions	Automate the CI/CD workflow

📁 Project Structure

├── .github/workflows/

│   └── deploy.yml           # GitHub Actions CI/CD pipeline

├── main.tf                  # Conditional Access policy definition

├── variables.tf             # Required input variables

├── providers.tf             # AzureAD provider setup

├── README.md                # Project documentation


🔐Prerequisites
»»» Azure AD App Registration with the following:
»»» API permissions: Policy.ReadWrite.ConditionalAccess
»»» A client secret (store the value, not the ID)

»»» Assign Required Directory Role:
»»» At least Security Administrator or Conditional Access Administrator

Create GitHub Secrets:
Secret Name	Description
ARM_CLIENT_ID	: App (client) ID
ARM_CLIENT_SECRET :	Client secret value (not ID!)
ARM_TENANT_ID	: Tenant (directory) ID

⚙️ How It Works
GitHub Actions triggers on:
»»» Push to main
»»» Manual workflow_dispatch
»»» Terraform authenticates using secrets from GitHub

A Conditional Access Policy is created or updated based on main.tf

📄 Sample Conditional Access Policy
hcl
Copy
Edit
##### resource "azuread_conditional_access_policy" "block_untrusted_access" {
  display_name = "Block Non-Compliant Devices from Untrusted Locations"
  state        = "enabled"

  conditions {
    users {
      included_users = ["All"]
      excluded_users = ["GuestsOrExternalUsers"]
    }

    sign_in_risk_levels = ["medium", "high"]
    user_risk_levels    = ["medium"]
    client_app_types    = ["browser", "mobileAppsAndDesktopClients"]

    applications {
      included_applications = ["All"]
    }

    devices {
      filter {
        mode = "exclude"
        rule = "device.operatingSystem eq \"Windows 7\""
      }
    }

    locations {
      included_locations = ["All"]
      excluded_locations = ["AllTrusted"]
    }

    platforms {
      included_platforms = ["android", "iOS", "windows"]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }

  session_controls {
    application_enforced_restrictions_enabled = true
    sign_in_frequency                         = 10
    sign_in_frequency_period                  = "hours"
    cloud_app_security_policy                 = "monitorOnly"
    disable_resilience_defaults               = false
  }
} #####

🔄 GitHub Actions Workflow (.github/workflows/deploy.yml)
yaml
Copy & Edit

##### name: Deploy Conditional Access Policy

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      with:
        terraform_version: 1.5.0

    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: |
        terraform plan \
          -var="client_id=${{ secrets.ARM_CLIENT_ID }}" \
          -var="client_secret=${{ secrets.ARM_CLIENT_SECRET }}" \
          -var="tenant_id=${{ secrets.ARM_TENANT_ID }}"

    - name: Terraform Apply
      run: |
        terraform apply -auto-approve \
          -var="client_id=${{ secrets.ARM_CLIENT_ID }}" \
          -var="client_secret=${{ secrets.ARM_CLIENT_SECRET }}" \
          -var="tenant_id=${{ secrets.ARM_TENANT_ID }}"
          
🧪 Testing the Setup
»»» Push a change to main
»»» Or manually trigger from GitHub Actions → "Deploy Conditional Access Policy"
»»» Check Azure Portal → Azure AD → Security → Conditional Access → Policies

# conditional-access
Conditional access policy deployment via GitHub actions and automating infrastructure with terraform
>>>>>>> 90de87058cf2bb479a311aef9bfa4db7af1f59dc
