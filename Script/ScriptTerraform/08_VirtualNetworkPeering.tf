/*# la ressource est deja créée dans Azure il faut donc qu'on l'import dans le fichier TFstate
resource "azurerm_resource_group" "Terra-RG-AAD" {
    name     = "RGO01-AAD"
    location = var.AzureRegion
}



resource "azurerm_virtual_network_peering" "example-1" {
  name                      = local.PeeringNameDevAad
  resource_group_name       = azurerm_resource_group.Terra-RG.name
  virtual_network_name      = azurerm_virtual_network.Terra-VN.name
  remote_virtual_network_id = azurerm_virtual_network.example-2.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = local.PeeringNameAadDev
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.example-2.name
  remote_virtual_network_id = azurerm_virtual_network.Terra-VN.id
}*/