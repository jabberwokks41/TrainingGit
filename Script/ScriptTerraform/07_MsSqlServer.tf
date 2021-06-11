resource "azurerm_sql_server" "Terra-MsSqlServer" {
  name                         = local.SqlServerName
  location = var.AzureRegion
  resource_group_name = azurerm_resource_group.Terra-RG.name
  version                      = var.SqlServerVersion
  administrator_login          = var.SqlServerLogin
  administrator_login_password = var.SqlServerPassword

  tags = local.tags

  depends_on = [azurerm_resource_group.Terra-RG]
}