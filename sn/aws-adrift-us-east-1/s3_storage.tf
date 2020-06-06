resource "aws_s3_bucket" "adrift-example-bucket" {
  bucket = "adrift-example-bucket"
  acl = "private"
  versioning {
    enabled = true
  }

  tags {
    Name = "doomwad-repo"
  }

}

