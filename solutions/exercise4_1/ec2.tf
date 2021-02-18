resource "aws_instance" "myInstance" {
  ami           = "ami-0233214e13e500f77"
  instance_type = "t2.micro"
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  yum -y install httpd
                  echo "<p> My Instance! </p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF
  tags = {
  Name = "MyTestInstance"
}
}
