resource "azurerm_virtual_network" "Terra-VN" { 
    name = local.VnetName 
    address_space = var.VnetAddress
    location = var.AzureRegion
    resource_group_name = azurerm_resource_group.Terra-RG.name

    dynamic "subnet" {
      for_each = local.subnet
      content {
        name           = subnet.value["name"]
        address_prefix = subnet.value["address_prefix"]
        security_group = subnet.value["security_group"]
      }
      
    }

/*

  subnet {
    name           = local.NomSubnetWeb
    address_prefix = var.AddressSubnetWeb
    security_group = azurerm_network_security_group.Terra-NSG[local.NomNsgWeb].id
  }

  subnet {
    name           = local.NomSubnetAut
    address_prefix = var.AddressSubnetAut
    security_group = azurerm_network_security_group.Terra-NSG[local.NomNsgAut].id
  }

  subnet {
    name           = local.NomSubnetApp
    address_prefix = var.AddressSubnetApp
    security_group = azurerm_network_security_group.Terra-NSG[local.NomNsgApp].id
  }
*/
  tags = local.tags

  depends_on = [azurerm_resource_group.Terra-RG, azurerm_network_security_group.Terra-NSG]


} 
    
