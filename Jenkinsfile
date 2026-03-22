pipeline {
    agent any
    
    environment {
        POLICY_SERVICE = 'http://localhost:8000'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📥 Checking out code...'
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo '🔒 Scanning infrastructure code...'
                    
                    def response = sh(
                        script: '''
python3 << 'PYTHON'
import requests
import json
import sys

try:
    with open('good-example.tf', 'r') as f:
        content = f.read()
    
    response = requests.post(
        'http://localhost:8000/analyze',
        json={'code_type': 'terraform', 'content': content}
    )
    result = response.json()
    print(json.dumps(result, indent=2))
    
    violations = len(result.get('violations', []))
    print(f"\\nFound {violations} violations")
    
    if result.get('decision') == 'BLOCK':
        print("❌ BLOCKING deployment - security violations detected!")
        sys.exit(1)
    else:
        print("✅ Security scan PASSED - safe to deploy")
        sys.exit(0)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
PYTHON
                        ''',
                        returnStatus: true
                    )
                    
                    if (response != 0) {
                        error('❌ Security scan failed - deployment blocked')
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                echo '🏗️  Building application...'
                echo '✅ Build completed successfully'
            }
        }
        
        stage('Deploy to Production') {
            steps {
                echo '🚀 Deploying to production environment...'
                echo '✅ Deployment successful!'
            }
        }
    }
    
    post {
        success {
            echo '✅✅✅ PIPELINE SUCCESS - Code deployed to production!'
        }
        failure {
            echo '❌❌❌ PIPELINE FAILED - Security violations prevented deployment'
        }
        always {
            echo '📊 Security scan statistics:'
            sh 'curl -s http://localhost:8000/metrics | python3 -m json.tool || true'
        }
    }
}
