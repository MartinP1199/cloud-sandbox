#!/usr/bin/env python3
import boto3
import json

def json_print(data):
     print(json.dumps(data, indent=4, default=str))

ec2 = boto3.client('ec2')
response = ec2.describe_key_pairs()
#print(response)

#parsed = json.loads(response)
json_print(response)