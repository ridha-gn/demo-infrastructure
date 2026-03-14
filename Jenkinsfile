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
        
        stage('Scan Good File') {
            steps {
                script {
                    echo '🔒 Scanning good-example.tf...'
                    
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
    
    if result.get('decision') == 'ALLOW':
        print("✅ GOOD FILE PASSED")
        sys.exit(0)
    else:
        print("❌ GOOD FILE FAILED")
        sys.exit(1)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
PYTHON
                        ''',
                        returnStatus: true
                    )
                    
                    if (response != 0) {
                        error('❌ good-example.tf failed security scan')
                    }
                }
            }
        }
        
        stage('Scan Bad File') {
            steps {
                script {
                    echo '🔒 Scanning bad-example.tf...'
                    
                    def response = sh(
                        script: '''
python3 << 'PYTHON'
import requests
import json
import sys

try:
    with open('bad-example.tf', 'r') as f:
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
        print("⚠️  BLOCKING deployment - security violations found")
        sys.exit(1)
    else:
        sys.exit(0)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
PYTHON
                        ''',
                        returnStatus: true
                    )
                    
                    if (response != 0) {
                        error('❌ Security violations found - BLOCKING DEPLOYMENT')
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                echo '🏗️  Building application...'
            }
        }
        
        stage('Deploy') {
            steps {
                echo '🚀 Deploying...'
            }
        }
    }
    
    post {
        always {
            echo '📊 Final metrics:'
            sh 'curl -s http://localhost:8000/metrics | python3 -m json.tool || true'
        }
    }
}
