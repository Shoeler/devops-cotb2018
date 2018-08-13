pipeline {
    agent none
    stages {
        stage('Build') {
            agent { label 'terraform' }
            environment {
                WKSPC = 'workspaces/dummy-tfdeploy/'
                TFSTATE = 'terraform.tfstate'
            }
            steps {
                sh '''
                   mkdir -p /mnt/azure/${WKSPC}
                   cd ${WKSPC}
                   terraform init -input=false -no-color
                   terraform plan -input=false -state=/mnt/azure/${WKSPC}/${TFSTATE} -no-color
                   terraform apply -input=false -auto-approve -state=/mnt/azure/${WKSPC}/${TFSTATE} -no-color
                '''
            }
        }
        stage('Test') {
            agent { label 'inspec' }
            steps {
                sh 'inspec exec --no-color -t azure:// tests/demo'
            }
        }
    }
}
