

resource "aws_instance" "web" {
  ami           = "ami-0da59f1af71ea4ad2"
  instance_type = "t2.micro"
  key_name = "docker-server"
  subnet_id = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
  count = 2

  tags = {
    Name = "WebServer"
  }

  provisioner "file" {
    source = "~/.ssh/docker-server.pem"
    destination = "/home/ec2-user/docker-server.pem"
  
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = "${file("~/.ssh/docker-server.pem")}"
    }  
  }
}

resource "aws_instance" "db" {
  ami           = "ami-0da59f1af71ea4ad2"
  instance_type = "t2.micro"
  key_name = "docker-server"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.allow_tls_db.id]

  tags = {
    Name = "DB Server"
  }
}
