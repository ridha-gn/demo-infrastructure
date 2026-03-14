#!/bin/bash

echo "================================"
echo "Testing GOOD file..."
echo "================================"

python3 << 'PYTHON'
import requests
import json

with open('good-example.tf', 'r') as f:
    content = f.read()

response = requests.post(
    'http://localhost:8000/analyze',
    json={'code_type': 'terraform', 'content': content}
)

result = response.json()
print(json.dumps(result, indent=2))

if result.get('decision') == 'ALLOW':
    print("\n✅ GOOD FILE PASSED!")
else:
    print("\n❌ GOOD FILE FAILED!")
PYTHON

echo ""
echo "================================"
echo "Testing BAD file..."
echo "================================"

python3 << 'PYTHON'
import requests
import json

with open('bad-example.tf', 'r') as f:
    content = f.read()

response = requests.post(
    'http://localhost:8000/analyze',
    json={'code_type': 'terraform', 'content': content}
)

result = response.json()
print(json.dumps(result, indent=2))

if result.get('decision') == 'BLOCK':
    print("\n✅ BAD FILE BLOCKED (as expected)!")
    print(f"\nFound {len(result.get('violations', []))} violations")
else:
    print("\n❌ BAD FILE PASSED (unexpected)!")
PYTHON
