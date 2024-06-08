# AWS 3-TIER APPLICATION INFRASTRUCTURE
This repo contains terraform script for a 3-tier application infrastructure.

**Project Deliverables**
1. Create a VPC with the help of Terraform having following attributes; 
- 3 Public and 3 Private Subnets. 
- NAT GW for Private Subnets. 
- IGW for Public Subnets. 
- 1 Route Table for Private Subnets. 
- 1 Route Table for Public Subnets. 
- Launch 3 EC2 instances with any OS of your choosing and install Nginx, Docker, NodeJS 20 via ec2 user data. 
- Launch 1 RDS in Create Private Subnet. ( MySQL or PSQL ) 
- Security Groups for each EC2 and RDS. 
  

2. Create a Load Balancer to be attached on EC2 instances that are in Private Subnets for accessing the Frontend and Backend Application. 
- Do it with the help of Terraform also create security group for load balancer with port 80 and 443 only. 

**Pre-requisites**
1. Log in to AWS account
2. Create an IAM user and generate access id and secret key. 
3. Download Terraform from https://developer.hashicorp.com/terraform/install
4. Add the folder containing terraform.exe path to the user variable path
5. Open CMD and navigate to the folder containing the terraform.exe 
```
terraform
aws configure
```
This command will ask you to add AWS Access Key ID, AWS Secret Access Key, Default region name , Default output format. 

6. Clone this repo and navigate to the directory containing this repo folder and execute following terraform commands in CMD.
```
terraform --version
terraform init
```
This command will initialize terraform agent

```
terraform plan
```
This command will display the resources that will be created along with its configuration. 

```
terraform apply
```
This command will create the resources defined in each .tf script. 

7. Checking ec2 VMs. Navigate to the folder containing .pem file 