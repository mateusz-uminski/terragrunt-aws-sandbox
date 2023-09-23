locals {
  org = var.org_abbreviated_name
}

resource "aws_key_pair" "reserved" {
  key_name   = "${local.org}-main-key-pair-sandbox"
  public_key = file("~/.ssh/id_rsa.pub")
}
