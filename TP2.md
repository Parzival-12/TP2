I. Network Security Group

3. Proofs
🌞 Prouver que ça fonctionne, rendu attendu :

la sortie du terraform apply
```
Terraform will perform the following actions:

  # azurerm_network_interface_security_group_association.nsg_association will be created
  + resource "azurerm_network_interface_security_group_association" "nsg_association" {
      + id                        = (known after apply)
      + network_interface_id      = "/subscriptions/e01b5125-7655-4382-8b6f-4c805b30f92e/resourceGroups/aaa/providers/Microsoft.Network/networkInterfaces/vm-nic"
      + network_security_group_id = (known after apply)
    }

  # azurerm_network_security_group.ssh_nsg will be created
  + resource "azurerm_network_security_group" "ssh_nsg" {
      + id                  = (known after apply)
      + location            = "uksouth"
      + name                = "ssh-nsg"
      + resource_group_name = "aaa"
      + security_rule       = (known after apply)
    }

  + resource "azurerm_network_security_rule" "ssh_inbound_rule" {
      + access                      = "Allow"
      + destination_address_prefix  = "*"
      + destination_port_range      = "22"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "Allow-SSH-From-My-IP"
      + network_security_group_name = "ssh-nsg"
      + priority                    = 100
      + protocol                    = "Tcp"
      + resource_group_name         = "aaa"
      + source_address_prefix       = "public-ip"
      + source_port_range           = "*"
    }

Plan: 3 to add, 0 to change, 0 to destroy.
```
une commande az pour obtenir toutes les infos liées à la VM
Commande: 
```az network nic show --resource-group aaa --name vm-nic --query 'networkSecurityGroup.id'
```
Resultat ```
"/subscriptions/e01b5125-7655-4382-8b6f-4c805b30f92e/resourceGroups/aaa/providers/Microsoft.Network/networkSecurityGroups/ssh-nsg"

``` 
une commande ssh fonctionnelle

vers l'IP publique de la VM
toujours sans mot de passe avec votre Agent SSH
``` 
PS C:\Program Files\Terraform> ssh aaa@172.167.153.200
```

🌞 Donner un nom DNS à votre VM
``` 
resource "azurerm_public_ip" "main" {
  name                = "vm-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  

# This is the correct location for the dns_name_label argument
  domain_name_label      = "serveur-ssh-tp2"
```

🌞 Un ptit output nan ?

créez un fichier outputs.tf à côté de votre main.tf
doit afficher l'IP publique et le nom DNS de la VM
```
  # azurerm_public_ip.main will be updated in-place
  ~ resource "azurerm_public_ip" "main" {
      + domain_name_label       = "serveur-ssh-tp2"
        id                      = "/subscriptions/e01b5125-7655-4382-8b6f-4c805b30f92e/resourceGroups/aaa/providers/Microsoft.Network/publicIPAddresses/vm-ip"
        name                    = "vm-ip"
        tags                    = {}
        # (12 unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_public_ip.main: Modifying... [id=/subscriptions/e01b5125-7655-4382-8b6f-4c805b30f92e/resourceGroups/aaa/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_public_ip.main: Modifications complete after 5s [id=/subscriptions/e01b5125-7655-4382-8b6f-4c805b30f92e/resourceGroups/aaa/providers/Microsoft.Network/publicIPAddresses/vm-ip]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

public_ip_address = "172.167.153.200"
```

3. Proooofs !¶
🌞 Proofs ! Donnez moi :

la sortie du terraform apply (ce qu'affiche votre outputs.tf)
``` 
azurerm_public_ip.main: Modifying... [id=/subscriptions/e01b5125-7655-4382-8b6f-4c805b30f92e/resourceGroups/aaa/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_public_ip.main: Modifications complete after 5s [id=/subscriptions/e01b5125-7655-4382-8b6f-4c805b30f92e/resourceGroups/aaa/providers/Microsoft.Network/publicIPAddresses/vm-ip]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

public_ip_address = "172.167.153.200"
```