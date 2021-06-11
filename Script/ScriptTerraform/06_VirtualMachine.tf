resource "azurerm_virtual_machine" "Terra-VM" {
  count = length(local.VmNames)
  name = element(local.VmNames, count.index)  
  location = var.AzureRegion
  resource_group_name = azurerm_resource_group.Terra-RG.name
  network_interface_ids = [element(local.NicIds, count.index)]
  
  vm_size = element(local.VmNames, count.index) == local.VmNameInf ? var.VmSizePerformance : var.VmSizeGeneral

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.VmImagePublisher
    offer     = var.VmImageOffer
    sku       = var.VmImageSku
    version   = var.VmImageVersion
  }

  plan {
    name = var.VmImageOffer
    publisher = var.VmImagePublisher
    product = var.VmImageSku
  }

  storage_os_disk {
    name              = element(local.OsDiskNames, count.index)  
    create_option     = var.OsDiskCreateOption
    managed_disk_type = var.OsDiskType
    disk_size_gb = var.OsDiskSize
  }
  /*storage_data_disk {
    name              = element(local.DataDiskNames, count.index)  
    create_option     = var.DataDiskCreateOption
    managed_disk_type = var.DataDiskType
    # nombre logic du disk on commence par 0 pour 1er, puis 1 pour le 2eme etc...
    lun = var.DataDiskLun
    disk_size_gb = var.DataDiskSize
  }*/
  os_profile {
    computer_name  = element(local.VmNames, count.index) 
    admin_username = var.VmLogin
    admin_password = element(local.VmPassword, count.index) 
  }
  os_profile_windows_config {
    provision_vm_agent = var.VmAgent
  }
  tags = local.tags
  depends_on = [azurerm_resource_group.Terra-RG, azurerm_network_security_group.Terra-NSG, azurerm_virtual_network.Terra-VN, azurerm_public_ip.Terra-PIP, azurerm_network_interface.Terra-NIC]
}