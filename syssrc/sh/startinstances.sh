#!/bin/bash
aws_cmd_desc="aws ec2 describe-instances"
aws_cmd_init="aws ec2 start-instances --instance-ids"
# Where Tag Name is Type and Value is $1
pattern=$1


for n in `$aws_cmd_desc --filters Name=tag-value,Values=$pattern|\
               grep InstanceId|awk '{print $2}'|sed s/\"//g|sed s/\,//`
do
	echo "Starting $n"
	$aws_cmd_init $n
done

