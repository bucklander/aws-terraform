data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

## Private compute instance(s)

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.subnet-b.id
  private_ips = ["10.12.2.100"]

  security_groups = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id, aws_security_group.allow_tls.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.buck-mbair.id
  user_data     = "apt-get install apache2 -y;systemctl start apache2"
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
  tags = {
    Name        = "foo"
    Environment = "development"
  }
}

## Public bastion instance

resource "aws_network_interface" "bastion" {
  subnet_id   = aws_subnet.subnet-a.id
  private_ips = ["10.12.1.100"]

  security_groups = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_eip" "bastion" {
  instance          = aws_instance.bastion.id
  vpc               = true
  network_interface = aws_network_interface.bastion.id
  depends_on        = [aws_internet_gateway.main]
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.buck-mbair.id

  subnet_id              = aws_subnet.subnet-a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name        = "bastion"
    Environment = "development"
  }
}
