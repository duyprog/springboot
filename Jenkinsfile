pipeline {
    agent any
    
    tools {
        maven 'Maven'
    }

    environment {
        BRANCH_BUILD = "master"
        CODE_DIR = "springboots"
        GIT_URL = "https://github.com/duyprog/springboot.git"
        DOCKER_REGISTRY="duypk2000/spring_boot"
        REGISTRY_CREDENTIAL = '4f456563-ee78-428e-8dea-b1c270c009a5'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '20', artifactNumToKeepStr: '20'))
    }

    stages {

        stage ('Build Spring Boot Jar file') {
            steps {
                // clone source code
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "${BRANCH_BUILD}"]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: "${CODE_DIR}"]],
                    submoduleCfg: [],
                    userRemoteConfigs: [[url: "${GIT_URL}"]]
                ])
                sh 'cd ${WORKSPACE}/${CODE_DIR} && mvn clean install -Dmaven.test.skip=true'

            }
        }

        stage('Build Docker Spring Boot Service') {

            steps {
                
                script {
                    dockerImage = docker.build $DOCKER_REGISTRY + ":${IMAGE_TAG}"
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
                sh "docker rmi $REGISTRY:$IMAGE_TAG"
            }
        }
    }
    post {
        always {
            deleteDir()
        }
    }
}
