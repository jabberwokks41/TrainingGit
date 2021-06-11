
param(
  [Parameter(Mandatory)]
  $env,

  [Parameter(Mandatory)]
  $os,

  [Parameter(Mandatory)]
  $app,
  
  [Parameter(Mandatory)]
  $souscriptionIdNew 
)

# Variables communes
$env = $env.ToUpper()
$app = $app.ToUpper()
$os = $os.ToUpper()

$resourceGroup = "RGO01-" + $env
$location = "francecentral"
$vmSize = "Standard_B2ms"
$vnetName = "VNE01-" + $env + "-INF01"
$subnetName = "SUB05-DEV01-AUT01"
$nsgName = "NSG01-" + $env + "-" + $app +"01"
$osDiskSize = "127"
$osDiskType = "Standard_LRS"
$pubName = "MicrosoftWindowsServer"
$offerName = "WindowsServer"
$skuName = "2019-Datacenter"
$dataDiskSize = "64"
$dataDiskType = "Standard_LRS"
$kv = "KVA01-" + $env

write $subnetName

write $nsgName


# tags ressources

<#
le vnet et le subnet sont deja crÃ©Ã©s
on va dans le portail azure pour recuperer le bon nom par environnement
on le renseigne dans les variables
#>

#az login

# module crÃ©Ã© pour gerer les souscriptions
# C:\Program Files\WindowsPowerShell\Modules\AzureCliEic.psm1
SetSubscriptionAzure $souscriptionIdNew

# tags des ressources

$tagVm1 = $env+"=VMA"
$tagVm2 = $env+"-VMA="+$app
$tagVm3 = $env+"-VMA-"+$app+"=01"

write $tagVm1
write $tagVm2
write $tagVm3

# creation nsg
az network nsg create --resource-group $resourceGroup --location $location --name $nsgName

# creation regle nsg
az network nsg rule create --resource-group $resourceGroup --name tse --nsg-name $nsgName --protocol Tcp `
  --direction Inbound --priority 1000 --source-address-prefixes * --source-port-ranges * --destination-address-prefixes * `
  --destination-port-range 3389 --access Allow

# le key vault a ete crÃ©Ã© en amont avec les 2 secrets
$mdp = az keyvault secret show --name mdpVm --vault-name $kv --query value --output tsv
$login = az keyvault secret show --name loginVm --vault-name $kv --query value --output tsv
$auth = "password"

write $mdp

write $login

# variables pour chaque vm
# $computerName = "APRE03VWRMQ01"
$computerName = "A"+ $env + "V" + $os + $app + "01" 
$vmName = "VMA01-" + $env + "-" + $computerName
$nicName = "NIC01-" + $env + "-" + $computerName
$osDiskName = "DKO01-" + $env + "-" + $computerName
$dataDiskName = "DKD01-" + $env + "-" + $computerName
$snapOsDisk = "SNP01-" + $env + "-" + "DKO01" + $app + "01"
$snapDataDisk = "SNP01-" + $env + "-" + "DKD01" + $app + "01"

# creation de la nic
az network nic create --name $nicName --resource-group $resourceGroup `
--vnet-name $vnetName --subnet $subnetName --network-security-group $nsgName

$image = $pubName + ":" + $offerName + ":" + $skuName + ":latest" 

# creation du disk data
az disk create -g $resourceGroup -n $dataDiskName --size-gb $dataDiskSize --sku $dataDiskType --image-reference-lun 0


az vm create -n $vmName -g $resourceGroup --admin-password $mdp --admin-username $login --authentication-type $auth --computer-name $computerName `
    --os-disk-caching ReadWrite --os-disk-name $osDiskName --os-disk-size-gb $osDiskSize --image $image --storage-sku $osDiskType --size $vmSize --attach-data-disks $dataDiskName --nics $nicName




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
