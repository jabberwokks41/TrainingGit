
locals {
  name = "${terraform.workspace}"
  tags = {"env" = "UMANIS", "usage" = "ETL"}
}

variable "tags" {
  default = {
    ctx = "labs"
  }
}

locals {
    ResourceGroupName = "RGO-UMANIS"
}

variable "AzureRegion" {
    type        = string
    default     = "francecentral"
}

locals {
    NsgNameArr = "NSG-${terraform.workspace}-ARR"
}

locals {
    NsgNameInf = "NSG-${terraform.workspace}-INF"
}

locals {
    NsgNameAut = "NSG-${terraform.workspace}-AUT"
}

locals {
    NsgNameApp = "NSG-${terraform.workspace}-APP"
}

locals {
    NsgNames = ["NSG-${terraform.workspace}-ARR", "NSG-${terraform.workspace}-INF", "NSG-${terraform.workspace}-AUT", "NSG-${terraform.workspace}-APP"]
}

locals {
    NsgSecurityRulesInf = {
        "name"                       = var.NsgSecurityRuleName 
        "priority"                   = var.NsgSecurityRulePriority 
        "direction"                  = var.NsgSecurityRuleDirection 
        "access"                     = var.NsgSecurityRuleAccess 
        "protocol"                   = var.NsgSecurityRuleProtocol
        "source_port_range"          = var.NsgSecurityRuleSourcePortRange 
        "destination_port_range"     = var.NsgSecurityRuleDestinationPortRange 
        "source_address_prefixes"      = var.NsgSecurityRuleSourceAddressPrefixes 
        "destination_address_prefix" = var.NsgSecurityRuleDestinationAddressPrefixes 
    }
}

locals {
    NsgSecurityRulesInf2 = [
        null,
        {
            name                       = var.NsgSecurityRuleName 
            priority                   = var.NsgSecurityRulePriority 
            direction                  = var.NsgSecurityRuleDirection 
            access                     = var.NsgSecurityRuleAccess 
            protocol                   = var.NsgSecurityRuleProtocol
            source_port_range          = var.NsgSecurityRuleSourcePortRange 
            destination_port_range     = var.NsgSecurityRuleDestinationPortRange 
            source_address_prefixes      = var.NsgSecurityRuleSourceAddressPrefixes 
            destination_address_prefix = var.NsgSecurityRuleDestinationAddressPrefixes 
        },
        null,
        null
    ]
}


variable "NsgSecurityRuleName" {
    type        = string
    default     = "RDP"
}

variable "NsgSecurityRulePriority" {
    type        = number
    default     = 100
}

variable "NsgSecurityRuleDirection" {
    type        = string
    default     = "Inbound"
}

variable "NsgSecurityRuleAccess" {
    type        = string
    default     = "Allow"
}

variable "NsgSecurityRuleProtocol" {
    type        = string
    default     = "Tcp"
}

variable "NsgSecurityRuleSourcePortRange" {
    type        = string
    default     = "*"
}

variable "NsgSecurityRuleDestinationPortRange" {
    type        = string
    default     = "3389"
}

variable "NsgSecurityRuleSourceAddressPrefixes" {
    type        = list(string)
    default     = ["188.94.111.111", "86.111.222.111"]
}

variable "NsgSecurityRuleDestinationAddressPrefixes" {
    type        = string
    default     = "*"
}

locals {
    VnetName = "VNE01-${terraform.workspace}"
}

variable "VnetAddress" {
    type = list(string)
    default = ["172.20.0.0/16"]
}

locals {
    SubnetNameArr = "SUB-${terraform.workspace}-1"
}

variable "SubnetAddressArr" {
    type = string
    default = "172.20.1.0/24"
}

locals {
    SubnetNameInf = "SUB-${terraform.workspace}-3"
}

variable "SubnetAddressInf" {
    type = string
    default = "172.20.3.0/24"
}

locals {
    SubnetNameAut = "SUB-${terraform.workspace}-5"
}

variable "SubnetAddressAut" {
    type = string
    default = "172.20.5.0/24"
}

locals {
    SubnetNameApp = "SUB-${terraform.workspace}-6"
}

variable "SubnetAddressApp" {
    type = string
    default = "172.20.6.0/24"
}

locals {
    NicNames = ["NIC-${terraform.workspace}VWARR01", "NIC-${terraform.workspace}VWINF01", "NIC-${terraform.workspace}VWAUT01", "NIC-${terraform.workspace}VWAPP01"]
    SubnetIds = [element(tolist(azurerm_virtual_network.Terra-VN.subnet), 0), element(tolist(azurerm_virtual_network.Terra-VN.subnet), 1), element(tolist(azurerm_virtual_network.Terra-VN.subnet), 2), 
        element(tolist(azurerm_virtual_network.Terra-VN.subnet), 3)]
    PrivateIpAdd = ["172.20.1.4", "172.20.3.4", "172.20.5.4", "172.20.6.4"]
}

locals {
    NicNameInf = "NIC-${terraform.workspace}VWINF01"
}

locals {
    subnet = [
        {
            name           = local.SubnetNameArr
            address_prefix = var.SubnetAddressArr
            security_group = azurerm_network_security_group.Terra-NSG[0].id
        },
        {
            name           = local.SubnetNameInf
            address_prefix = var.SubnetAddressInf
            security_group = azurerm_network_security_group.Terra-NSG[1].id
        },
        {
            name           = local.SubnetNameAut
            address_prefix = var.SubnetAddressAut
            security_group = azurerm_network_security_group.Terra-NSG[2].id
        },
        {
            name           = local.SubnetNameApp
            address_prefix = var.SubnetAddressApp
            security_group = azurerm_network_security_group.Terra-NSG[3].id
        }
    ]
}

locals {
    VmNameInf = "A${terraform.workspace}VWINF01"
}

locals {
    VmNames = ["A${terraform.workspace}VWARR01", "A${terraform.workspace}VWINF01", "A${terraform.workspace}VWAUT01", "A${terraform.workspace}VWAPP01"]
    NicIds = [azurerm_network_interface.Terra-NIC[0].id, azurerm_network_interface.Terra-NIC[1].id, azurerm_network_interface.Terra-NIC[2].id, 
        azurerm_network_interface.Terra-NIC[3].id]
    OsDiskNames = ["DIK_OS_A${terraform.workspace}VWARR01", "DIK_OS_A${terraform.workspace}VWINF01", "DIK_OS_A${terraform.workspace}VWAUT01", 
        "DIK_OS_A${terraform.workspace}VWAPP01"]
    VmPassword = ["***", "***", "***", "***"]
}

locals {
    PipNameInf = "IPU_${terraform.workspace}VWINF01"
}

variable "PublicIpAdressAlloc" {
    type = string
    default = "Static"
}

variable "PublicIpAddressIdleTimeout" {
    type = number
    default = 30   
}

locals {
    IpConfigNames = ["IPR_${terraform.workspace}VWARR01", "IPR_${terraform.workspace}VWINF01", "IPR_A${terraform.workspace}VWAUT01", 
        "IPR_A${terraform.workspace}VWAPP01"]
}

variable "IpConfigPrivateIpAdressAlloc" {
    type = string
    default = "Static"
}

variable "VmSizeGeneral" {
    type = string
    default = "Standard_B2s"
}

variable "VmSizePerformance" {
    type = string
    default = "Standard_B2ms"
}

variable "VmImagePublisher" {
    type = string
    default = "skylarkcloud"
}

variable "VmImageOffer" {
    type = string
    default = "iis-on-windows-server-2019"
}

variable "VmImageSku" {
    type = string
    default = "iis-on-windows-server-2019"
}

variable "VmImageVersion" {
    type = string
    default = "1.0.0"
}

variable "OsDiskCreateOption" {
    type = string
    default = "FromImage"
}

variable "OsDiskType" {
    type = string
    default = "Standard_LRS"
}

variable "OsDiskSize" {
    type = number
    default = 127
}

variable "DataDiskCreateOption" {
    type = string
    default = "Empty"
}

variable "DataDiskType" {
    type = string
    default = "Standard_LRS"
}

variable "DataDiskLun" {
    type = number
    default = 0
}

variable "DataDiskSize" {
    type = number
    default = 127
}

variable "VmLogin" {
    type = string
    default = "setup"
}

variable "VmAgent" {
    type = bool
    default = true
}

locals {
    SqlServerName = lower("A${terraform.workspace}MOSQL01")
}

variable "SqlServerLogin" {
    type = string
    default = "user01"
}

variable "SqlServerPassword" {
    type = string
    default = "****"
}

variable "SqlServerVersion" {
    type = string
    default = "12.0"
}

locals {
    PeeringNameDevAad = "${local.VnetName}-to-VNE01-AAD"
}

locals {
    PeeringNameAadDev = "VNE01-AAD-to-${local.VnetName}"
}