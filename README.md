# Demo Infrastructure

This shows automated security scanning in Jenkins.

## Files
- `good-example.tf` - Secure (passes scan)
- `bad-example.tf` - Insecure (fails scan)
- `Jenkinsfile` - Pipeline definition

## Expected Results
- good-example.tf: ✅ PASS
- bad-example.tf: ❌ FAIL (blocks deployment)
# test
