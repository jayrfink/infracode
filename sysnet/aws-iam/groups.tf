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
