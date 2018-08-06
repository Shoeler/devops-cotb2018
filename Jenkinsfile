pipeline {
    agent none
    stages {
        stage('Build') {
            agent { label 'terraform' }
            steps {
                sh 'cd workspaces/dummy-tfdeploy && terraform init --input=false && terraform plan -input=false && terraform apply -input=false -auto-approve'
            }
        }
        stage('Test') {
            agent { label 'inspec' }
            steps {
                sh 'inspec exec -t azure:// tests/demo'
            }
        }
    }
    post {
        agent { label 'terraform'}
        always {
            sh 'cd workspaces/dummy-tfdeploy && terraform init --input=false && terraform destroy --force'
        }
    }
}
