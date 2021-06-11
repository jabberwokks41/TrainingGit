resource "azurerm_network_interface" "Terra-NIC" { 
  count = length(local.NicNames)
  name = element(local.NicNames, count.index)  
  location = var.AzureRegion
  resource_group_name = azurerm_resource_group.Terra-RG.name
  
  ip_configuration {
    name                          = element(local.IpConfigNames, count.index)
    subnet_id                     = element(tolist(local.SubnetIds), count.index).id
    private_ip_address_allocation = var.IpConfigPrivateIpAdressAlloc
    private_ip_address            = element(local.PrivateIpAdd, count.index)
    public_ip_address_id          = element(local.NicNames, count.index) == local.NicNameInf ? azurerm_public_ip.Terra-PIP.id : null
  }

  tags = local.tags
  depends_on = [azurerm_resource_group.Terra-RG, azurerm_network_security_group.Terra-NSG, azurerm_virtual_network.Terra-VN, azurerm_public_ip.Terra-PIP]
}