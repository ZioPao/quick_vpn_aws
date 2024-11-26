
# WireGuard VPN Server on AWS

Sets up a WireGuard VPN server on AWS using an EC2 instance.

## Prerequisites

- AWS account with appropriate credentials
- Terraform installed
- WireGuard client installed on your device

## Resources Created

- IAM role and instance profile for Systems Manager access
- Security group allowing WireGuard traffic (UDP 51820)
- EC2 instance (by default a t2.micro) running Ubuntu 24.04 LTS
- Elastic IP address for a fixed public IP

## Usage

1. Clone this repository
2. Initialize Terraform:

terraform init


3. Apply the configuration:

terraform apply


4. After deployment, you can connect to the instance using AWS Systems Manager Session Manager
5. The WireGuard configuration will be available in `/etc/wireguard/`

## Outputs

- `vpn_ip`: The public IP address of your VPN server

## Security Considerations

- The security group allows inbound WireGuard traffic from any IP (0.0.0.0/0)
- AWS Systems Manager is used for secure instance access instead of SSH

## Clean Up

To destroy all resources:

terraform destroy
