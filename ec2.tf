resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "tf_key_aa"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${"tf_key_aa"}.pem"

  provisioner "local-exec" {
    command = "chmod 600 ${"tf_key_aa"}.pem"
  }
}

resource "aws_instance" "bastion_aa" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2_key_pair.key_name
  subnet_id     = random_shuffle.pb_subnet_shuffle.result[0]
  associate_public_ip_address = true
  depends_on = [aws_security_group.public_sg]
  vpc_security_group_ids = [aws_security_group.public_sg.id]

provisioner "file" {
    source      = var.local_filepath
    destination = var.remote_filepath
connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.user
    private_key = file("${aws_key_pair.ec2_key_pair.key_name}.pem")
    timeout     = "4m"
  }
}

provisioner "remote-exec" {
    inline = [ "chmod 600 ${var.remote_filepath}" ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.user
      private_key = file("${aws_key_pair.ec2_key_pair.key_name}.pem")
      timeout     = "5m"  
}
}
  tags = {
    Name = var.private_ec2_name
  }
}

resource "aws_instance" "ec2_instance_private" {
  count           = length(var.ec2_names)
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.ec2_key_pair.key_name
  subnet_id       = aws_subnet.pv_subnet[count.index].id
  depends_on      = [aws_security_group.private_sg]
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  user_data = templatefile("${path.module}/userdata.sh", {})

  tags = {
    Name = var.ec2_names[count.index]
  }
}

data "aws_instances" "frontend_instance" {
    depends_on = [ aws_instance.ec2_instance_private ]
  filter {
    name   = "tag:Name"
    values = ["frontend"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instances" "backend_instance" {
    depends_on = [ aws_instance.ec2_instance_private ]
  filter {
    name   = "tag:Name"
    values = ["backend"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}