pipeline {
    agent any

    environment {
        // Define any environment variables here
        BUILD_TOOL = 'maven' // Since we're using a Maven-based project
        DEPLOY_ENV = 'production'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    echo 'Building the project with Maven...'
                    sh 'mvn clean install'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo 'Running tests with Maven...'
                    sh 'mvn test'
                }
            }
        }

        stage('Package') {
            steps {
                script {
                    echo 'Packaging the application with Maven...'
                    sh 'mvn package'
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying application...'
                script {
                    if (env.DEPLOY_ENV == 'production') {
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

    post {
        always {
            echo 'Cleaning up...'
            cleanWs()
        }
        success {
            echo 'Build succeeded!'
            // Optionally, notify team via email or Slack
        }
        failure {
            echo 'Build failed!'
            // Optionally, notify team via email or Slack
        }
    }
}
