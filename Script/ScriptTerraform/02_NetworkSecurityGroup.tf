resource "azurerm_network_security_group" "Terra-NSG" {
  count = length(local.NsgNames)
  name = element(local.NsgNames, count.index)  
  location = var.AzureRegion

  resource_group_name = azurerm_resource_group.Terra-RG.name

  
  security_rule {
    name                       = var.NsgSecurityRuleName 
    priority                   = var.NsgSecurityRulePriority 
    direction                  = var.NsgSecurityRuleDirection 
    access                     = var.NsgSecurityRuleAccess 
    protocol                   = var.NsgSecurityRuleProtocol
    source_port_range          = var.NsgSecurityRuleSourcePortRange 
    destination_port_range     = var.NsgSecurityRuleDestinationPortRange 
    source_address_prefixes      = var.NsgSecurityRuleSourceAddressPrefixes 
    destination_address_prefix = var.NsgSecurityRuleDestinationAddressPrefixes 
  }



  #security_rule = element(local.NsgNames, count.index) == local.NsgNameInf ? local.NsgSecurityRulesInf : {}
  

 /* dynamic "security_rule" {
    for_each = local.security_rule
    content {
      name      = "${local.plan[0].name}"
      product   = "${local.plan[0].product}"
      publisher = "${local.plan[0].publisher}"
    }
  }*/



  /*security_rule {
    name                       = element(local.NsgNames, count.index) == local.NsgNameInf ? var.NsgSecurityRuleName : null
    priority                   = element(local.NsgNames, count.index) == local.NsgNameInf ? var.NsgSecurityRulePriority : null
    direction                  = element(local.NsgNames, count.index) == local.NsgNameInf ? var.NsgSecurityRuleDirection : null
    access                     = element(local.NsgNames, count.index) == local.NsgNameInf ? var.NsgSecurityRuleAccess : null
    protocol                   = element(local.NsgNames, count.index) == local.NsgNameInf ? var.NsgSecurityRuleProtocol : null
    source_port_range          = element(local.NsgNames, count.index) == local.NsgNameInf ? var.NsgSecurityRuleSourcePortRange : null
    destination_port_range     = element(local.NsgNames, count.index) == local.NsgNameInf ? var.NsgSecurityRuleDestinationPortRange : null
    source_address_prefixes      = element(local.NsgNames, count.index) == local.NsgNameInf ? var.NsgSecurityRuleSourceAddressPrefixes : null
    destination_address_prefix = element(local.NsgNames, count.index) == local.NsgNameInf ? var.NsgSecurityRuleDestinationAddressPrefixes : null
  }*/

  tags = local.tags

  depends_on = [azurerm_resource_group.Terra-RG]

}   