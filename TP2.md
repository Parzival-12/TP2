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

```
az network nic show --resource-group aaa --name vm-nic --query 'networkSecurityGroup.id'
```
Resultat 
```
"/subscriptions/e01b5125-7655-4382-8b6f-4c805b30f92e/resourceGroups/aaa/providers/Microsoft.Network/networkSecurityGroups/ssh-nsg"

``` 
une commande ssh fonctionnelle

vers l'IP publique de la VM
toujours sans mot de passe avec votre Agent SSH
``` 
PS C:\Program Files\Terraform> ssh aaa@20.162.250.29 -i "C:\Users\chims\.ssh\Cloud_tp1"
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

public_ip_address = "20.162.250.29"

```
une commande ssh fonctionnelle

vers l'IP publique de la VM
toujours sans mot de passe avec votre Agent SSH

```
PS C:\Program Files\Terraform> ssh aaa@20.162.250.29 -i "C:\Users\chims\.ssh\Cloud_tp1"
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Sep 15 11:01:21 UTC 2025

  System load:  0.0               Processes:             110
  Usage of /:   5.5% of 28.89GB   Users logged in:       0
  Memory usage: 30%               IPv4 address for eth0: 10.0.1.4
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
New release '22.04.5 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Mon Sep 15 10:57:06 2025 from 37.169.117.114
aaa@aaa:~$
```
changement de port :
modifiez le port d'écoute du serveur OpenSSH sur la VM pour le port 2222/tcp
prouvez que le serveur OpenSSH écoute sur ce nouveau port (avec une commande ss sur la VM)
prouvez qu'une nouvelle connexion sur ce port 2222/tcp ne fonctionne pas à cause du NSG

``` 
sudo nano /etc/ssh/sshd_config
#       $OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Include /etc/ssh/sshd_config.d/*.conf

Port 2222 #
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key
```

``` 
aaa@aaa:~$ sudo systemctl restart sshd
```

```
aaa@aaa:~$ sudo ss -tlnp | grep 2222
LISTEN    0         128                0.0.0.0:2222             0.0.0.0:*        users:(("sshd",pid=2540,fd=3))                                   
LISTEN    0         128                   [::]:2222                [::]:*        users:(("sshd",pid=2540,fd=4))                                   
aaa@aaa:~$
```
prouvez qu'une nouvelle connexion sur ce port 2222/tcp ne fonctionne pas à cause du NSG
```
PS C:\Program Files\Terraform> ssh -p 2222 aaa@20.162.250.29
ssh: connect to host 20.162.250.29 port 2222: Connection timed out
PS C:\Program Files\Terraform>
```
une commande ssh fonctionnelle vers le nom de domaine (pas l'IP)
vers le nom de domaine de la publique
toujours sans mot de passe avec votre Agent SSH
``` ```
