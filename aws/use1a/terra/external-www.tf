resource "aws_security_group" "http" {
  name        = "http-world"
  description = "http-world"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [ 
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "http-world"
  }
}

resource "aws_security_group" "https" {
  name        = "https-world"
  description = "https-world"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [ 
       "0.0.0.0/0",
      ]
  }

  tags = {
    Name = "https-world"
  }
}
