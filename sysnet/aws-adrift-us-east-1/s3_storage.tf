resource "aws_s3_bucket" "adrift-example-bucket" {
  bucket = "adrift-example-bucket"
  acl = "private"
  versioning {
    enabled = false
  }

  tags {
    Name = "doomwad-repo"
  }

}

