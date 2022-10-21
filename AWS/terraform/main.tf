data "aws_ami" "ubuntu-free-tier" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical
}

# --- instances ---
resource "random_pet" "terrabuntu" {
  count = var.instances_count
  length = 1
}

resource "aws_instance" "web" {
  count = var.instances_count
  ami           = data.aws_ami.ubuntu-free-tier.id
  instance_type = "t2.micro"

  tags = {
    Name = "tf-docker-${random_pet.terrabuntu[count.index].id}"
  }

  key_name = var.key_name
  user_data = "${file(var.script_file_path)}"

}