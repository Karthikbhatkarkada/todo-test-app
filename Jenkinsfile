pipeline {
  agent any

  environment {
    COMPARTMENT_OCID = credentials('oci-compartment-ocid')
    SUBNET_OCID      = credentials('oci-subnet-ocid')
    OCI_CONFIG_PATH  = credentials('oci-config-file')
  }

  triggers {
    githubPush()
  }

  stages {
    stage('Clone Repo') {
      steps {
        git branch: 'main',
            credentialsId: 'github-credentials',
            url: 'https://github.com/Karthikbhatkarkada/todo-test-app.git'
      }
    }

    stage('Build App') {
      steps {
        dir('app') {
          sh 'npm install'
        }
      }
    }

    stage('Build Image via Packer') {
      steps {
        withEnv(["OCI_CLI_CONFIG_FILE=${OCI_CONFIG_PATH}"]) {
          dir('packer') {
            sh 'packer init .'
            sh '''
              packer build \
                -var compartment_ocid=$COMPARTMENT_OCID \
                -var subnet_ocid=$SUBNET_OCID \
                ubuntu-todo.pkr.hcl
            '''
          }
        }
      }
    }
  }
}
