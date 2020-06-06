#!/bin/bash
# Where Tag Name is Type and Value is $1
aws_cmd_desc="aws ec2 describe-instances"
aws_cmd_stop="aws ec2 stop-instances --instance-ids"
pattern=$1


for n in `$aws_cmd_desc --filters Name=tag-value,Values=$pattern|\
               grep InstanceId|awk '{print $2}'|sed s/\"//g|sed s/\,//`
do
	echo "Stopping $n"
	$aws_cmd_stop $n
done

