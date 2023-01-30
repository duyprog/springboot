library {
    lib('shared-library')
}
pipeline {
    agent any
    
    tools {
        maven 'Maven3.6'
    }

    environment {
        // WORKSPACE = "/var/lib/jenkins/workspace"
        WORKDIR = "springboot"
        GIT_URL = "https://github.com/duyprog/springboot.git"
        DOCKER_REGISTRY="duypk2000/spring_boot"
        DOCKER_CREDENTIAL = credentials("DOCKER_CREDENTIAL")
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
        stage ('Test Shared Library') {
            steps {
                sayHello 'test'
            }
        }
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

        // stage('SonarQube Analysis') {
        //     environment {
        //         SCANNER_HOME = tool 'Sonar-scanner'
        //     }

        //     steps {
        //         withSonarQubeEnv('Sonar'){
        //             sh '''$SCANNER_HOME/bin/sonar-scanner \
        //             -Dsonar.projectKey=springboot \
        //             -Dsonar.projectName=springboot \
        //             -Dsonar.sources=src \
        //             -Dsonar.java.binaries=target/classes/ \
        //             -Dsonar.projectVersion=${BUILD_NUMBER}-${GIT_COMMIT_SHORT}'''
        //         }
        //     }
        // }

        // stage('SQuality Gate') {
        //     steps {
        //         timeout(time: 1, unit: 'MINUTES'){
        //             waitForQualityGate abortPipeline: true
        //         } 
        //     }
        // }

        stage('Build Docker Spring Boot Service') {
            
            environment {
                SERVICE_NAME = 'spring'
            }
            steps {
                dir("${WORKDIR}"){
                    sh "docker build . -t $DOCKER_REGISTRY:$IMAGE_TAG"
                }

            }
        }

        stage('Push Docker Image') {

            steps{
                sh "docker login --username ${DOCKER_CREDENTIAL_USR} -p ${DOCKER_CREDENTIAL_PSW}"
                sh "docker push $DOCKER_REGISTRY:$IMAGE_TAG"
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
