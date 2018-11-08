pipeline {
  agent {
    kubernetes {
      label UUID.randomUUID().toString()
      containerTemplate {
        name 'terraform'
        image 'hashicorp/terraform:latest'
        ttyEnabled true
        command 'cat'
      }
    }
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '30'))
  }

  environment {
    AWS_ACCESS_KEY_ID = credentials('aws.my-account.id')
    AWS_SECRET_ACCESS_KEY = credentials('aws.my-account.key')
  }

  stages {
    stage('Initialize') {
      steps {
        container('terraform') {
          sh '''
            # calculate env name based on git repository name
            export TF_VAR_env=$(git remote get-url origin | sed -e "s/.*env-//" | sed -e "s/.git//")
            
            # This config would be better put inside config.tf, but due to a Terraform limitation you
            # cannot use variables in a backend configuration. Therefore this is the only way to
            # dynamically set the "key" value so that it is unique for each environment.
            #
            # Note that the "region" value below is NOT the region that your Terraform infrastructure
            # is being deployed to. It is only the region of the state storage bucket and will be the
            # same across all environments at your company.
            terraform init \\
              -backend-config "bucket=my-company-terraform-state" \\
              -backend-config "region=us-east-1" \\
              -backend-config "key=${TF_VAR_env}.tfstate" \\
              -backend-config "encrypt=true"
          '''
        }
      }
    }
    stage('Plan') {
      steps {
        container('terraform') {
          sh '''
            # calculate env name based on git repository name
            export TF_VAR_env=$(git remote get-url origin | sed -e "s/.*env-//" | sed -e "s/.git//")
            
            terraform plan -input=false -out .tfplan
          '''
        }
      }
    }
    stage('Apply') {
      when {
        expression { env.BRANCH_NAME == 'master' }
      }
      steps {
        container('terraform') {
          timeout(time: 5, unit: 'MINUTES') {
            input message: 'Continuing may change or destroy existing infrastructure, be sure to review the plan stage before continuing'
          }
          sh 'terraform apply -input=false -auto-approve .tfplan'
        }
      }
    }
  }
}
