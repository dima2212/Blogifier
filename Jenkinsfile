pipeline {
    agent any
    stages{
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
