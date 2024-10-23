# trunk-ignore(trivy/AVD-AWS-0178): VPC flow logs not required for demo environment
resource "aws_vpc" "gitops_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "gitops-vpc-${local.environment}"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.gitops_vpc.id
}

resource "aws_internet_gateway" "gitops_igw" {
  vpc_id = aws_vpc.gitops_vpc.id

  tags = {
    Name = "gitops-igw-${local.environment}"
  }
}

resource "aws_route_table" "gitops_rt" {
  vpc_id = aws_vpc.gitops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gitops_igw.id
  }

  tags = {
    Name = "gitops-rt-${local.environment}"
  }
}

# trunk-ignore(trivy/AVD-AWS-0164): Public IP required for internet access
resource "aws_subnet" "gitops_subnet" {
  vpc_id                  = aws_vpc.gitops_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "gitops-subnet-${local.environment}"
  }
}

resource "aws_route_table_association" "gitops_rta" {
  subnet_id      = aws_subnet.gitops_subnet.id
  route_table_id = aws_route_table.gitops_rt.id
}

resource "aws_security_group" "grafana_sg" {
  name        = "grafana_sg"
  description = "Grafana Server security group"
  vpc_id      = aws_vpc.gitops_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "grafana_ingress" {
  description       = "Inbound traffic to grafana web interface"
  security_group_id = aws_security_group.grafana_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000

  tags = {
    Name = "grafana-ingress-sg-rule-${local.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# trunk-ignore(trivy/AVD-AWS-0104): Unrestricted egress traffic permitted for demo purposes
resource "aws_vpc_security_group_egress_rule" "grafana_egress" {
  description       = "Outbound traffic from grafana server"
  security_group_id = aws_security_group.grafana_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "grafana-egress-sg-rule-${local.environment}"
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

# trunk-ignore(trivy/AVD-AWS-0028): IMDS token not required for demo
# trunk-ignore(trivy/AVD-AWS-0131): EBS encryption not required for demo
resource "aws_instance" "grafana_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.gitops_subnet.id
  vpc_security_group_ids = [aws_security_group.grafana_sg.id]
  user_data              = file("userdata.tftpl")

  tags = {
    Name = "grafana-server-${local.environment}"
  }
}

check "grafana_check" {
  data "http" "grafana" {
    url    = "http://${aws_instance.grafana_server.public_ip}:3000"
    method = "HEAD"
  }

  assert {
    condition     = data.http.grafana.status_code == 200
    error_message = "${data.http.grafana.url} returned an unhealthy status code"
  }
}
