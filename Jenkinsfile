pipeline {
    agent { label 'workernode' }

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/bharadwaja1998/spring-petclinic.git', branch: 'main'
            }
        }

        stage('Java Build and Sonar Scan') {
            steps {
                script {
                    withSonarQubeEnv('SONAR') {
                        sh '''
                            mvn clean package sonar:sonar \
                              -Dsonar.host.url=https://sonarcloud.io \
                              -Dsonar.organization=Sai Bharadwaja Chilukuri \
                              -Dsonar.projectName=spring-petclinic \
                              -Dsonar.projectKey=sai-bharadwaja-chilukuri
                        '''
                    }
                }
            }
        }

        stage('Upload to JFrog') {
            steps {
                script {
                    rtUpload (
                        serverId: 'JFROG',
                        spec: '''{
                            "files": [
                                {
                                    "pattern": "target/*.jar",
                                    "target": "java-app-libs-release/"
                                }
                            ]
                        }'''
                    )

                    rtPublishBuildInfo (
                        serverId: 'JFROG'
                    )
                }
            }
        }

        stage('Docker image build') {
            steps {
                sh 'docker image build -t java:1.0 -f dockerfile .'
                sh 'docker image ls'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar'
            junit '**/target/surefire-reports/*.xml'
        }
        success {
            echo '✅ This is a good pipeline'
        }
        failure {
            echo '❌ This is a failed pipeline'
        }
    }
}