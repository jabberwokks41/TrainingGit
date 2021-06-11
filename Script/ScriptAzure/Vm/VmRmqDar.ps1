# Variables communes
$resourceGroup = "rgo-test-ju"
$location = "francecentral"
$vmName = "VMA01-test-ADEV02VWRMQ01"
$vmSize = "Standard_B2ms"
$nsgName = "NSG01-test-RMQ01"
$nicName = "NIC01-test-ADEV02VWRMQ01"
$vnetName = "VNE01-test-INF01"
$subnetName = "SUB07-test-RMQ01"
$computerName = "ADtestVWRMQ01"
$osDiskName = "DKO01-test-ADEV02VWRMQ01"
$osDiskSize = "127"
$osDiskType = "Standard_LRS"
$souscriptionId = "xxx-xxx"
$pubName = "MicrosoftWindowsServer"
$offerName = "WindowsServer"
$skuName = "2019-Datacenter"
$dataDiskName = "DKD01-test-ADEV02VWRMQ01"
$dataDiskSize = "64"
$dataDiskType = "Standard_LRS"

<#
le vnet et le subnet sont deja créés
on va dans le portail azure pour recuperer le bon nom par environnement
on le renseigne dans les variables
#>

az login
az account set -s $souscriptionId

# creation nsg
az network nsg create --resource-group $resourceGroup --location $location --name $nsgName 

# creation regle nsg
az network nsg rule create --resource-group $resourceGroup --name tse --nsg-name $nsgName --protocol Tcp `
    --direction Inbound --priority 1000 --source-address-prefixes * --source-port-ranges * --destination-address-prefixes * `
    --destination-port-range 3389 --access Allow

# creation de la nic
az network nic create --name $nicName --resource-group $resourceGroup `
    --vnet-name $vnetName --subnet $subnetName --network-security-group $nsgName

$image = $pubName + ":" + $offerName + ":" + $skuName + ":latest" 
# creation du disk data
az disk create -g $resourceGroup -n $dataDiskName --size-gb $dataDiskSize --sku $dataDiskType --image-reference-lun 0

# le key vault a ete créé en amont avec les 2 secrets et il est dans la meme souscription mais dans un autre ressource group
$mdp = az keyvault secret show --name mdpvm --vault-name testkvdar --query value --output tsv
$login = az keyvault secret show --name login --vault-name testkvdar --query value --output tsv
$auth = "password"

az vm create -n $vmName -g $resourceGroup --admin-password $mdp --admin-username $login --authentication-type $auth --computer-name $computerName `
    --os-disk-caching ReadWrite --os-disk-name $osDiskName --os-disk-size-gb $osDiskSize --image $image --size $vmSize --attach-data-disks $dataDiskName --nics $nicName


<# creer un script powershell pour:
 1) ajouter la regle firewall rabbitmq tcp 5672
 2) supprimer le driver DVD E:\
 3) ajouter le disk data E:\DATA
 4) mettre les vm dans le domaine
 5) installer un iis

Deposer le script powershell dans un storage account 

Jouer la commande ci dessous avec les bons parametres, ce qui va executer le script ps1
 
 az vm extension set \
--publisher Microsoft.Compute \
--version 1.8 \
--name CustomScriptExtension \
--vm-name $VmName \
--resource-group $ResourceGroupName \
--settings '{"fileUris":["https://my-assets.blob.core.windows.net/public/SetupSimpleSite.ps1"],"commandToExecute":"powershell.exe -ExecutionPolicy Unrestricted -file SetupSimpleSite.ps1"}'
#>


