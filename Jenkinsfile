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
                dir(".github"){
                 sh  'ls -ltr'
                }
            }   
        }    
        stage('prod'){
            steps{
                echo "its a production"
            }
        }
    }
}


