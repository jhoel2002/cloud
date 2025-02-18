
variable "instancias" {
  description = "Nombre de las instancias"
  //count
  # type = list(string)
  //foreach
  type = set(string)
  # default = [ "apache", "mysql", "jumpserver" ]
  default = ["apache"]
}

resource "aws_instance" "public_instance" {
  //foreach
  # for_each = toset(var.instancias) cuando la variable es una lista
  for_each = var.instancias
  //count
  # count = length(var.instancias)
  ami           = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type
  subnet_id = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [ aws_security_group.sg_public_instance.id ]
  user_data = file("scripts/userdata.sh")
  tags = {
    "Name" = "${each.value}-${local.sufix}"
  }

}

resource "aws_instance" "monitoring_instance" {
  count = var.enable_monitoring == 1 ? 1 : 0
  ami           = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type
  subnet_id = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [ aws_security_group.sg_public_instance.id ]
  user_data = file("scripts/userdata.sh")
  tags = {
    "Name" = "Monitoreo-${local.sufix}"
  }
}

# variable "cadena" {
#   type = string
#   default = "ami-123,AMI-AAV,ami-12f"
# }