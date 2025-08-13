pipeline {
    agent any

    environment {
        COMPARTMENT_OCID = 'ocid1.tenancy.oc1..aaaaaaaa6jvn6ty3gevdog7phzcnbh7x3ek4suj4cwyd7imjhe62qwv7x2iq'
        SUBNET_OCID      = 'ocid1.subnet.oc1.ap-hyderabad-1.aaaaaaaa4nwj6qaqilt7vfwfgq5ygal266s57effy6hotkv3lozgitdesviq'
        AD               = 'yFYg:AP-HYDERABAD-1-AD-1'
        KEY_FILE         = '/var/lib/jenkins/.oci/oci_api_key.pem'
        FINGERPRINT      = '49:85:65:68:89:5f:9e:4e:59:a8:e9:11:68:f5:b0:07'
        TENANCY_OCID     = 'ocid1.tenancy.oc1..aaaaaaaa6jvn6ty3gevdog7phzcnbh7x3ek4suj4cwyd7imjhe62qwv7x2iq'
        USER_OCID        = 'ocid1.user.oc1..aaaaaaaaaoc2keqeg3eivr4vadd4llduiput5fu5ftprtps3rt5o2rzmhz6q'
        GIT_REPO         = 'https://github.com/Karthikbhatkarkada/todo-test-app.git'
    }

    options {
        timestamps()
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Install Packer') {
            steps {
                sh '''
                if ! command -v packer >/dev/null 2>&1; then
                  echo "Installing Packer..."
                  sudo apt-get update -y
                  sudo apt-get install -y unzip
                  curl -fsSL https://releases.hashicorp.com/packer/1.11.2/packer_1.11.2_linux_amd64.zip -o packer.zip
                  sudo unzip -o packer.zip -d /usr/local/bin
                  rm -f packer.zip
                else
                  echo "Packer already installed"
                fi
                '''
            }
        }

        stage('Packer Init') {
            steps {
                sh 'packer init .'
            }
        }

        stage('Packer Build') {
            steps {
                sh '''
                packer build \
                  -var compartment_ocid=${COMPARTMENT_OCID} \
                  -var subnet_ocid=${SUBNET_OCID} \
                  -var availability_domain="${AD}" \
                  -var key_file=${KEY_FILE} \
                  -var fingerprint=${FINGERPRINT} \
                  -var tenancy_ocid=${TENANCY_OCID} \
                  -var user_ocid=${USER_OCID} \
                  ubuntu-todo.pkr.hcl
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Packer image build completed successfully."
        }
        failure {
            echo "❌ Packer build failed."
        }
    }
}
