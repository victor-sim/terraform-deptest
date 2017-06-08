#!/bin/bash
export INSTANCE_ID=$(cat instanceId.txt)
echo "Instance ID to terminate is \"$INSTANCE_ID\""
echo "aws ec2 terminate-instances --instance-ids $INSTANCE_ID"
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
echo "Waiting instance termination"
echo "aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID"
echo "Done"

