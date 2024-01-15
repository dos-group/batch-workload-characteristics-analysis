locals {
  ssh_key_exists = fileexists("ssh_key.pem")

  # Define the content of the SSH key based on its existence
  ssh_private_key_content = local.ssh_key_exists ? file("ssh_key.pem") : tls_private_key.ssh_key[0].private_key_pem
  ssh_public_key_content = local.ssh_key_exists ? file("ssh_key.pub") : tls_private_key.ssh_key[0].public_key_openssh
}

# Create a new TLS private key only if it doesn't exist
resource "tls_private_key" "ssh_key" {
  count     = local.ssh_key_exists ? 0 : 1
  algorithm = "RSA"
}

# Create local file for private key only if it doesn't exist
resource "local_file" "ssh_key" {
  count         = local.ssh_key_exists ? 0 : 1
  content       = tls_private_key.ssh_key[0].private_key_pem
  filename      = "ssh_key.pem"
  file_permission = "0600" # chmod 600
}

# Create local file for public key only if it doesn't exist
resource "local_file" "ssh_key_pub" {
  count         = local.ssh_key_exists ? 0 : 1
  content       = tls_private_key.ssh_key[0].public_key_openssh
  filename      = "ssh_key.pub"
}
