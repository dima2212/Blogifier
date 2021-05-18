pipeline {
    agent any
    stages{
        stage('Initialize'){
            def dockerHome = tool 'Docker'
            env.PATH = "${dockerHome}/bin:${env.PATH}"
        }   
        stage("Chekout"){
            steps{
                cleanWs()
                checkout( [$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[credentialsId: 'github_credentials', url: 'https://github.com/dima2212/Blogifier']]])
            }
        }
        stage("DockerBuild"){
            steps{
                sh "docker build --network=host -t localhost:8081/blogifier:myapp -f Dockerfile ."
            }
        }
    }
}
