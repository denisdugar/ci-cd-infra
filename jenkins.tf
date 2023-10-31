data "aws_ami" "latest_ubuntu_linux" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "template_file" "user_data_jenkins" {
  template = "${file("user_data_jenkins.sh")}"
}


resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.latest_ubuntu_linux.id
  instance_type = "t2.micro"
  key_name      = "personalkey"
  subnet_id = aws_subnet.test_subnet_public_1.id
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  user_data       = data.template_file.user_data_jenkins.rendered
  tags = {
    Name = "jenkins"
  }
}