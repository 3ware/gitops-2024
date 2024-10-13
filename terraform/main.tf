resource "aws_vpc" "gitops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "gitops-vpc"
  }
}

resource "aws_internet_gateway" "gitops_igw" {
  vpc_id = aws_vpc.gitops_vpc.id

  tags = {
    Name = "gitops-igw"
  }
}

resource "aws_route_table" "gitops_rt" {
  vpc_id = aws_vpc.gitops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gitops_igw.id
  }

  tags = {
    Name = "gitops-rt"
  }
}

resource "aws_subnet" "gitops_subnet" {
  vpc_id                  = aws_vpc.gitops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "gitops-subnet"
  }
}

resource "aws_route_table_association" "gitops_rta" {
  subnet_id      = aws_subnet.gitops_subnet.id
  route_table_id = aws_route_table.gitops_rt.id
}

resource "aws_security_group" "gitops_sg" {
  name        = "gitops_sg"
  description = "Allow port 3000"
  vpc_id      = aws_vpc.gitops_vpc.id
}

# trunk-ignore(trivy/AVD-AWS-0104): Unrestricted ingress traffic permitted for demo purposes
resource "aws_vpc_security_group_egress_rule" "grafana_ingress" {
  description       = "Inbound traffic to grafana web interface"
  security_group_id = aws_security_group.gitops_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000

  tags = {
    Name = "grafana-ingress-sg-rule"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# trunk-ignore(trivy/AVD-AWS-0104): Unrestricted egress traffic permitted for demo purposes
resource "aws_vpc_security_group_egress_rule" "grafana_egress" {
  description       = "Outbound traffic from grafana server"
  security_group_id = aws_security_group.gitops_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 0

  tags = {
    Name = "grafana-egress-sg-rule"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "grafana_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.gitops_subnet.id
  vpc_security_group_ids = [aws_security_group.gitops_sg.id]
  user_data              = file("userdata.tftpl")

  tags = {
    Name = "grafana-server"
  }
}
