#creation du pare-feu, avec pour nom ssh_nsg

resource "azurerm_network_security_group" "ssh_nsg" {
  name                = "ssh-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
resource "azurerm_network_security_rule" "ssh_inbound_rule" {
  name                        = "Allow-SSH-From-My-IP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "172.167.153.200" #limite l'acces SSH a mon adresse ip public
  destination_address_prefix  = "*"

  network_security_group_name = azurerm_network_security_group.ssh_nsg.name
  resource_group_name         = azurerm_resource_group.main.name
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.ssh_nsg.id
}