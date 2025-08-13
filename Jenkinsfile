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
                -var availability_domain='yFYg:AP-HYDERABAD-1-AD-1' \
                -var key_file=/var/lib/jenkins/.oci/oci_api_key.pem \
                -var fingerprint='49:85:65:68:89:5f:9e:4e:59:a8:e9:11:68:f5:b0:07' \
                -var tenancy_ocid='ocid1.tenancy.oc1..aaaaaaaa6jvn6ty3gevdog7phzcnbh7x3ek4suj4cwyd7imjhe62qwv7x2iq' \
                -var user_ocid='ocid1.user.oc1..aaaaaaaaaoc2keqeg3eivr4vadd4llduiput5fu5ftprtps3rt5o2rzmhz6q' \
                ubuntu-todo.pkr.hcl
            '''
          }
        }
      }
    }
  }
}
