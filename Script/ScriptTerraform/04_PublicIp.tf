resource "azurerm_public_ip" "Terra-PIP" {
  name                    = local.PipNameInf
  location = var.AzureRegion
  resource_group_name = azurerm_resource_group.Terra-RG.name
  allocation_method       = var.PublicIpAdressAlloc
  idle_timeout_in_minutes = var.PublicIpAddressIdleTimeout

  tags = local.tags

  depends_on = [azurerm_resource_group.Terra-RG, azurerm_network_security_group.Terra-NSG, azurerm_virtual_network.Terra-VN]
}