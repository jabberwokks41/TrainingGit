resource "azurerm_resource_group" "Terra-RG" {
    name     = local.ResourceGroupName
    location = var.AzureRegion
    tags = local.tags
}



