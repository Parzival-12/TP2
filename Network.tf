#creation du pare-feu, avec pour nom ssh_nsg

# Crée un groupe de sécurité réseau (NSG) qui agira comme un pare-feu
resource "azurerm_network_security_group" "ssh_nsg" {
  name                = "ssh-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Définit une règle pour le NSG qui autorise le trafic SSH
# uniquement depuis votre adresse IP publique
resource "azurerm_network_security_rule" "ssh_inbound_rule" {
  name                        = "Allow-SSH-From-My-IP"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "20.162.250.29"
  destination_address_prefix  = "*"
  
  network_security_group_name = azurerm_network_security_group.ssh_nsg.name
  resource_group_name         = azurerm_resource_group.main.name
}

# Associe le NSG à l'interface réseau de votre VM
# C'est une étape cruciale pour que les règles prennent effet
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.ssh_nsg.id
