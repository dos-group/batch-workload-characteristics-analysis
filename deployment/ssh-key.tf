resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

resource "local_file" "ssh_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "ssh_key.pem"
  file_permission = "0600" # chmod 600
}

resource "local_file" "ssh_key_pub" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "ssh_key.pub"
}