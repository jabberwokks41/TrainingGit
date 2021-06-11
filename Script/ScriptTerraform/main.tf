provider "azurerm" { 
    version = "~>2.22"
    features {}

        /*subscription_id = "xxx"
        client_id       = "xxx"
        client_secret   = "xxx"
        tenant_id       = ""xxx"*/
}

/*terraform { 
    backend "azurerm" {

        subscription_id = "xxx"
        client_id       = "xxx"
        client_secret   = "xxx"
        tenant_id       = "xxx"

        resource_group_name  = "RG-TF-TEST"
        storage_account_name = "satftest"
        container_name       = "cotftest"
        key                  = "terraform.tfstate"

    }
}*/

