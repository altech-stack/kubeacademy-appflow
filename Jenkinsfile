pipeline {
  agent {
    kubernetes {
      yamlFile 'JenkinsPod.yaml'
    }
  }
  environment {
    DOCKER_IMAGE_NAME = 'website'
    DOCKER_HUB_ACCOUNT = 'USERNAME'
  }
  stages {
    stage('Clone Repository') {
      steps {
        checkout scm
      }
    }
    stage('Build Hugo Site') {
      steps {
        container('hugo') {
          dir ("site") {
              sh "hugo"
          }
        }
      }
    }
    // stage('Validate HTML') {
    //   steps {
    //     container('html-proofer') {
    //       dir ("site") {
    //           sh ("htmlproofer public --internal-domains ${env.JOB_NAME} --external_only --only-4xx")
    //       }
    //     }
    //   }
    // }
    stage('Docker Build & Push Image') {
      steps {
        container('docker') {
            dir ("site") {
                sh ("docker build -t ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} .")
                sh ("docker push ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}")
                sh ("docker tag ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${JOB_NAME}-latest")
                sh ("docker push ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:latest")
            }
        }
      }
    }
  // stage('Deploy to Staging') {
  //   when { not { branch "master" } }
  //   steps {
  //     container('kubectl') {
  //         dir ("manifests") {
  //             writeFile file: "overlays/staging/kustomization.yaml", text: """
  //             bases:
  //             - ../../base
  //             namespace: staging
  //             patchesJson6902:
  //             - target:
  //                 group: extensions
  //                 version: v1beta1
  //                 kind: Ingress
  //                 name: website
  //               path: ingress_patch.yaml
  //             images:
  //             - name: hugo
  //               newName: ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}
  //               newTag: "${env.BUILD_NUMBER}"
  //           """

  //           sh ("kubectl apply -k overlays/staging")
  //         }
  //     }
  //   }
  // }
  // stage('Deploy to Production') {
  //   when { branch "master" }
  //   steps {
  //     container('kubectl') {
  //         dir ("manifests") {
  //           writeFile file: "overlays/production/kustomization.yaml", text: """
  //             bases:
  //             - ../../base
  //             namespace: production
  //             patchesJson6902:
  //             - target:
  //                 group: extensions
  //                 version: v1beta1
  //                 kind: Ingress
  //                 name: website
  //               path: ingress_patch.yaml
  //             images:
  //             - name: hugo
  //               newName: ${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}
  //               newTag: "${env.BUILD_NUMBER}"
  //           """

  //           sh ("kubectl apply -k overlays/production")
  //         }
  //     }
  //   }
  // }
 }
}