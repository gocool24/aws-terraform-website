pipeline {
    agent any

    tools {
        terraform 'terraform-1.8.0' // Use a Terraform version you've configured in Jenkins Global Tool Configuration
    }

    environment {
        // Store AWS credentials securely in Jenkins Credentials Manager
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        TF_VAR_bucket_name    = "gocool.space" // <-- CHANGE THIS to the same name used in main.tf
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code from GitHub...'
                git 'https://github.com/gocool24/aws-terraform-website.git'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                echo 'Running Terraform Init and Plan...'
                sh 'terraform init'
                sh 'terraform plan' // Optional: for review
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Applying Terraform configuration...'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Deploy Website to S3') {
            steps {
                echo 'Deploying index.html to S3 bucket...'
                // The aws s3 sync command copies files to the bucket
                sh "aws s3 sync . s3://${TF_VAR_bucket_name} --exclude 'Jenkinsfile' --exclude '.git/*' --exclude '*.tf'"
            }
        }
    }

    post {
        success {
            echo "Pipeline successful! ✨"
        }
        failure {
            echo "Pipeline failed. 😢"
        }
    }
}
