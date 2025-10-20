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
                              -Dsonar.organization=sai-bharadwaja-chilukuri \
                              -Dsonar.projectName=spring-petclinic \
                              -Dsonar.projectKey=bharadwaja1998_spring-petclinic
                        '''
                    }
                }
            }
        }

        stage('Artifact Upload to JFrog') {
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

        stage('Docker Image build') {
            steps {
                // Authenticate Docker to JFrog using Jenkins credentials
                withCredentials([usernamePassword(
                    credentialsId: 'jfrog', 
                    usernameVariable: 'JFROG_USER', 
                    passwordVariable: 'JFROG_PASS'
                )]) {
                    sh '''
                        curl -u $JFROG_USER:$JFROG_PASS -O https://trialpucn28.jfrog.io/artifactory/java-app-libs-release/spring-petclinic-3.5.0-SNAPSHOT.jar
                        docker build -t java:2.0 -f dockerfile .
                    '''
                }
            }
        }
        stage('TRIVY-Docker Image Scan') {
            steps {
                sh 'trivy image java:2.0'
               }
        }

        stage('ECR Push-Docker Image') {
           steps {
               sh '''
                      docker tag java:2.0 700903221071.dkr.ecr.us-east-1.amazonaws.com/prod/javaimage:latest 
                      docker push 700903221071.dkr.ecr.us-east-1.amazonaws.com/prod/javaimage:latest
                   '''
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
