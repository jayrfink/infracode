#!/usr/bin/python3
import boto3
import sys
import os
import random
import time

client = boto3.client('ec2')
image_id=""
instance_type= ""
vpc_id= ""
subnet_id=""
key_name=""
group_id=""
instance_id= sys.argv[1]


def createAMI(instance_id):
    response = client.create_image(
    Description="Clone-of-"+instance_id,
    instance_id=instance_id,
    Name=instance_id+'-clone'+str(random.randint(1,100)),
    NoReboot=True
    )
    image_id=response["image_id"]
    status=""
    while status!="available":
        response=client.describe_images(image_ids=[image_id])
        status=response["Images"][0]["State"]
        print ("AMI  Status: "+status)
        time.sleep(200)

    print("Image Created!")
    return image_id



def do_clone(image_id):
    details= client.describe_instances(instance_ids=[instance_id])
    instance_type= details["Reservations"][0]["Instances"][0]["instance_type"]
    vpc_id= details["Reservations"][0]["Instances"][0]["vpc_id"]
    subnet_id=details["Reservations"][0]["Instances"][0]["subnet_id"]
    group_id=details["Reservations"][0]["Instances"][0]["SecurityGroups"][0]["group_id"]
    key_name= details["Reservations"][0]["Instances"][0]["key_name"]
    response=client.run_instances(image_id=image_id , instance_type=instance_type , Securitygroup_ids=[group_id],MinCount=1, MaxCount=1)
    print("Your Cloned Instance Id is:  "+response["Instances"][0]["instance_id"] )

    newinstance_id=response["Instances"][0]["instance_id"]
    client.create_tags(
    Resources=[newinstance_id],
    Tags=[
        {
            'Key': 'Name',
            'Value': 'Clone'
        }
    ]
)



image_id=createAMI(instance_id)
do_clone(image_id)
