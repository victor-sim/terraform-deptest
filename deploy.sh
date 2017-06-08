#!/bin/bash
export AmiId=$(cat result.json | python -c "import json,sys;obj=json.load(sys.stdin);print obj['ImageId'];")

echo "Apply terraform"
terraform apply -var 'ami_id=$AmiId' -var 'repo_url=$REPO_URL' terraform

export INSTANCE_ID=$(cat instanceId.txt)
echo "Instance ID is $INSTANCE_ID"
echo "Wait instance ok"
aws ec2 wait instance-status-ok --instance-ids $INSTANCE_ID
echo "Done"

export IPADDR=$(cat ipaddress.txt)
echo "You can access instance at http://$IPADDR"