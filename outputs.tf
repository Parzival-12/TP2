output "public_ip_address" {
  description = "The public IP address of the virtual machine."
  value       = azurerm_public_ip.main.ip_address
}

output "vm_dns_name" {
  description = "The DNS name (FQDN) of the virtual machine."
  value       = azurerm_public_ip.main.fqdn
}