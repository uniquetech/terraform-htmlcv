# LOAD BALANCER #
resource "aws_elb" "web" {
  name = "nginx-elb"

  subnets         = aws_subnet.subnet[*].id
  security_groups = [aws_security_group.elb-sg.id]
  instances       = aws_instance.nginx[*].id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  tags = {
      Name = "${var.environment_tag}-elb"
  }
}

# INSTANCES #
resource "aws_instance" "nginx" {
  count                  = var.instance_count
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet[count.index % var.subnet_count].id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [aws_iam_role_policy.allow_s3_all]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)

  }

  provisioner "file" {
    content = <<EOF
access_key =
secret_key =
security_token =
use_https = True
bucket_location = UK

EOF
    destination = "/home/ec2-user/.s3cfg"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo cp /home/ec2-user/.s3cfg /root/.s3cfg",
      "sudo pip install s3cmd",
      "s3cmd get s3://${aws_s3_bucket.web_bucket.id}/website/index.html .",
      "sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html"
    ]
  }

  tags = {
      Name = "${var.environment_tag}-nginx${count.index + 1}"
  }
}