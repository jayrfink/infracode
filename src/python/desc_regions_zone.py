#!/usr/bin/python3
# describe all regions or the current zones
# usage: PN regions|zones
import boto3
import sys

ec2     = boto3.client('ec2')
oper    = sys.argv[1]         

def descec2regions():
	response = ec2.describe_regions()
	print('Regions:',response['Regions'])


def descmyec2zones():
	response = ec2.describe_availability_zones()
	print('Availability Zones:', response['AvailabilityZones'])


if oper in ['regions']:
	descec2regions()
	sys.exit()


if oper in ['zones']:
	descmyec2zones()
	sys.exit()


print("Error: Incorect syntax: regions|zones (zones show in current region)")

