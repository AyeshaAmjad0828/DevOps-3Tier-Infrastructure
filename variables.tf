# variables.tf

variable "tf_key" {
  description = "The key name for the EC2 instance"
  type        = string
  default     = "tf_key_aa"  // Or any default you prefer
}

#####################################  EC2  ###############################################

variable "user" {
  description = "EC2 instance user"
  type        = string
  default     = "ubuntu"
}

variable "ec2_names" {
  description = "Names of EC2 instances"
  type        = list(string)
  default     = ["frontend", "backend", "metabase"]
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type = string
  default     = "ami-01e444924a2233b07"  
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type = string
  default     = "t2.micro"       
}

variable "local_filepath" {
  description = "Local file to copy"
  type        = string
  default     = "tf_key_aa.pem" 
}

variable "remote_filepath" {
  description = "Remote file path on the instance"
  type        = string
  default     = "/home/ubuntu/tf_key_aa.pem"  
}

variable "private_ec2_name" {
  description = "Names of EC2 instances"
  type        = string
  default     = "bastion_aa"
}
                                                                   
#####################################  VPC  ################################################

variable "zones" {
  description = "availability zones for subnets"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "pb_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "pv_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default = {
    Name = "vpc_aa"
  }
}

variable "subnet_tags" {
  description = "Tags for subnets"
  type        = map(string)
  default = {
    Name = "subnet_aa"
  }
}

variable "igw_tags" {
  description = "Tags for internet gateway"
  type        = map(string)
  default = {
    Name = "igw_aa"
  }
}

variable "natgw_tags" {
  description = "Tags for NAT gateway"
  type        = map(string)
  default = {
    Name = "natgw_aa"
  }
}

variable "public_route_table_tags" {
  description = "Tags for public route table"
  type        = map(string)
  default = {
    Name = "my-public-route-table"
  }
}

variable "private_route_table_tags" {
  description = "Tags for private route table"
  type        = map(string)
  default = {
    Name = "my-private-route-table"
  }
}


################################### SECURITY GROUP ######################################

variable "public_sg_tag" {
  description = "Tags for public security group"
  type        = map(string)
  default = {
    Name = "public-sg"
  }
}

variable "private_sg_tag" {
  description = "Tags for private security group"
  type        = map(string)
  default = {
    Name = "private-sg"
  }
}

variable "rds_sg_tag" {
  description = "Tags for RDS security group"
  type        = map(string)
  default = {
    Name = "rds-sg"
  }
}

variable "load_balancer_sg_tag" {
  description = "Tags for Load Balancer security group"
  type        = map(string)
  default = {
    Name = "lb-sg"
  }
}

variable "ssh_port" {
  description = "SSH port number"
  type = number
  default     = 22
}

variable "http_port" {
  description = "HTTP port number"
  type = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port number"
  type = number
  default     = 443
}

variable "custom_port" {
  description = "Custom port number"
  type = number
  default     = 5000
}

variable "postgressql_port" {
  description = "PostgessQL port number"
  type = number
  default     = 5432
}



######################################## DB #############################################



variable "db_subnet_group_tag" {
  description = "postgress subnet group tag"
  type        = map(string)
  default = {
    Name = "PostgressQL Subnet Group"
  }
}