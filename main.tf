provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "ssm_role" {
  name = "ec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2_ssm_profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_security_group" "vpn_sg" {
  name        = "vpn_security_group"
  description = "Security group for WireGuard VPN"

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "WireGuard VPN port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "vpn" {
  ami           = "ami-0866a3c8686eaeeba"   # Ubuntu 24.04 LTS in US-EAST-1
  instance_type = "t2.micro"
  
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids   = [aws_security_group.vpn_sg.id]

  user_data = file("setup_wireguard_ubuntu.sh")
  
}

output "test"{
  value = file("setup_wireguard_ubuntu.sh")
}

output "vpn_ip" {
  value = aws_instance.vpn.public_ip
}