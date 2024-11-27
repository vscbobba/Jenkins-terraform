@Library('mylibrary') _
pipeline {
    agent any
    stages{
        stage('test'){
            steps{
                fileFunc()
            }
        }
        stage('pre-prod'){
            steps{
                echo "its preprod"
            }
        }    
        stage('prod'){
            steps{
                echo "its a production"
            }
        }
    }
}


