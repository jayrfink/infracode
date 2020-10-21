resource "aws_iam_user" "jrf" {
  name = "jrf"

  tags = {
    Name = "Jay_Fink"
    Dept = "EOD"
  }
}

resource "aws_iam_access_key" "jrf" {
  user = aws_iam_user.jrf.name
}


resource "aws_iam_group_membership" "syssec" {
  name = "syssec"
  group = "syssec"
  users = [
    "jrf",
    "jill",
  ]
}

resource "aws_iam_group_membership" "systor" {
  name = "systor"
  group = "systor"
  users = [
    "jack",
    "jill",
  ]
}
resource "aws_iam_group_membership" "sysadm" {
  name = "sysadm"
  group = "sysadm"
  users = [
    "jrf",
    "jill",
    "jack",
   ]
}
resource "aws_iam_group_membership" "netsec" {
  name = "netsec"
  group = "netsec"
  users = [
    "jrf",
    "jill",
   ]
}

resource "aws_iam_group_policy" "systor-s3-policy" {
  name = "systor-s3-policy"
  group = aws_iam_group.systor.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::somebucket",
        "arn:aws:s3:::somebucket/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_policy" "sysadm-ec2-policy" {
  name = "sysadm-ec2-policy"
  group = aws_iam_group.sysadm.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
         "Effect":"Allow",
         "Action":"ec2:Describe*",
         "Resource":"*"
      },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances",
            "ec2:StopInstances",
            "ec2:RebootInstances"
         ],
         "Resource":[
            "arn:aws:ec2:us-east-1:111122223333:instance/*"
         ]
    }
  ]
}
EOF
}

