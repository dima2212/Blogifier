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
                sh "docker build --network=host -t localhost:8083/blogifier:default -f Dockerfile ."
            }
        }
        stage("Push"){
            steps{
                sh "docker login localhost:8083 --username admin --password 338239"
                sh "docker push localhost:8083/blogifier:default "
            }
        }
    }
}
