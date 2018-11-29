# env-terraform-example

Example skeleton for managing a single Terraform infrastructure as code environment

## Prerequisites

- Jenkins server with a Kubernetes cloud attached (you can use a vanilla Jenkins server if you change the agent block in the Jenkinsfile)
- AWS credentials loaded through the Jenkins credentials plugin or sufficient IAM role privileges attached to your Jenkins server
- Dedicated S3 bucket to store your state files with its name entered in the Jenkinsfile's bucket configuration

## Usage

- Fork or import a copy of this repository into your git hosting service
- Create a "Multibranch Pipeline" job in Jenkins
- Add Terraform resources to main.tf to build your infrastructure
