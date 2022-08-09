pipeline {
    agent any
    
    tools {
        maven 'Maven'
    }

    environment {
        BRANCH_BUILD = "master"
        CODE_DIR = "springboots"
        GIT_URL = "https://github.com/duyprog/springboot.git"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: 10))
    }

    stages {

        stage ('Pull source code to workspace') {
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
            }
            // sh 'cd ${WORKSPACE}/'
        }

        // stage('Build Spring Boot Service') {

        //     steps {
            

        //     }
        // }
    }
    post {
        always {
            deleteDir()
        }
    }
}