pipeline {
    agent any
    stages{
        stage("Checkout"){
        steps{
            cleanWs()
            checkout( [$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[credentialsId: 'Github', url: 'https://github.com/dima2212/Blogifier']]])
        }
    }
}