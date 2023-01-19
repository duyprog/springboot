pipeline {
    agent any
    
    tools {
        maven 'Maven3.6.0'
    }

    environment {
        // WORKSPACE = "/var/lib/jenkins/workspace"
        WORKDIR = "springboot"
        GIT_URL = "https://github.com/duyprog/springboot.git"
        DOCKER_REGISTRY="duypk2000/spring_boot"
    }
    
    parameters {
        string(name: 'BRANCH_BUILD', defaultValue: 'master', description: 'Branch name')
        string(name: 'REGISTRY_CREDENTIAL', defaultValue: '', description: 'Registry credential include username and password to login Docker Hub')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Image tag of Docker Image')

    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '20', artifactNumToKeepStr: '20'))
    }

    stages {

        stage ('Build Spring Boot Jar file') {
            steps {
                // clone source code
                dir("${WORKDIR}"){
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "${BRANCH_BUILD}"]],
                        userRemoteConfigs: [[url: "${GIT_URL}"]]
                    ])
                    sh 'mvn clean install -Dmaven.test.skip=true'
                }
            }
        }

        stage('Build Docker Spring Boot Service') {
            
            environment {
                SERVICE_NAME = 'spring'
            }
            steps {
                dir("${WORKDIR}"){
                    script {
                        dockerImage = docker.build DOCKER_REGISTRY + ":$IMAGE_TAG"
                    }
                }

            }
        }

        stage('Push Docker Image') {

            steps{
                script {
                    docker.withRegistry('', REGISTRY_CREDENTIAL) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Cleaning up') {
            steps {
                sh "docker rmi $DOCKER_REGISTRY:$IMAGE_TAG"
            }
        }
    }
    post {
        always {
            deleteDir()
        }
    }
}
