pipeline {
    agent any
    
    environment {
        POLICY_SERVICE = 'http://localhost:8000'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
            }
        }
        
        stage('Scan Good File') {
            steps {
                script {
                    echo 'Scanning good-example.tf...'
                    
                    sh '''
                        RESPONSE=$(curl -s -X POST ${POLICY_SERVICE}/analyze \
                          -H "Content-Type: application/json" \
                          -d "{\\"code_type\\":\\"terraform\\",\\"content\\":\\"$(cat good-example.tf)\\"}")
                        
                        echo "$RESPONSE"
                        
                        if echo "$RESPONSE" | grep -q '"decision":"ALLOW"'; then
                            echo "✅ good-example.tf PASSED"
                        else
                            echo "❌ good-example.tf FAILED"
                            exit 1
                        fi
                    '''
                }
            }
        }
        
        stage('Scan Bad File') {
            steps {
                script {
                    echo 'Scanning bad-example.tf...'
                    
                    sh '''
                        RESPONSE=$(curl -s -X POST ${POLICY_SERVICE}/analyze \
                          -H "Content-Type: application/json" \
                          -d "{\\"code_type\\":\\"terraform\\",\\"content\\":\\"$(cat bad-example.tf)\\"}")
                        
                        echo "$RESPONSE"
                        
                        if echo "$RESPONSE" | grep -q '"decision":"BLOCK"'; then
                            echo "❌ bad-example.tf has violations (expected)"
                            echo "BLOCKING deployment!"
                            exit 1
                        else
                            echo "⚠️  bad-example.tf passed (unexpected!)"
                        fi
                    '''
                }
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building application...'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
    
    post {
        always {
            echo 'Getting metrics...'
            sh 'curl -s ${POLICY_SERVICE}/metrics || true'
        }
    }
}
