pipeline {
    agent any 
   
    parameters {
        choice(name: 'BRANCH_NAME', choices: ['develop', 'bugfix', 'master'], description: 'Branch name to deploy from')
        choice(name: 'DEPLOY_ENV', choices: ['staging', 'production'], description: 'Deployment environment')
    }   
   
    environment {
        // define env varibale 
        BUILD_TOOL = 'MAVEN'
        DEPLOY_ENV = 'PROD'
    }
    tools {
        maven 'Maven 3.9.8' // Specify the name of the Maven installation configured in Jenkins
    }
    stages {
        stage('checkout') {
            steps {
                echo 'checkout code...'
                checkout scm
            }    
        }        
        
        stage('Build') {
            steps {
                 script {
                     echo 'building maven project'
                     sh 'mvn clean install'
                 }           
            } 
        }    
        
        stage('test') {
            steps {
                 script {
                     echo 'running test with maven'
                     sh 'mvn test'
                 }           
            } 
        }  
        
        stage('Deploy') {
            when {
                expression {
                    return ['develop', 'bugfix', 'master'].contains(params.BRANCH_NAME)
                }
            }
            steps {
                echo "Deploying application to ${params.DEPLOY_ENV} environment from ${params.BRANCH_NAME} branch..."
                script {
                    if (params.DEPLOY_ENV == 'production') {
                        echo 'Deploying to production...'
                        // Using SCP to deploy to a production server
                        sh '''
                        scp -i /path/to/your/key target/my-spring-boot-app.jar user@production.server:/path/to/deploy/
                        ssh -i /path/to/your/key user@production.server 'sudo systemctl restart my-spring-boot-app'
                        '''
                    } else {
                        echo 'Deploying to staging...'
                        // Using SCP to deploy to a staging server
                        sh '''
                        scp -i /path/to/your/key target/my-spring-boot-app.jar user@staging.server:/path/to/deploy/
                        ssh -i /path/to/your/key user@staging.server 'sudo systemctl restart my-spring-boot-app'
                        '''
                    }
                }
            }
        }
    }
}
