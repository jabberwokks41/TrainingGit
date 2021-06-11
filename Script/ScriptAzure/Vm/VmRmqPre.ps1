
param(
    [Parameter(Mandatory)]
    $env,

    [Parameter(Mandatory)]
    $os,

    [Parameter(Mandatory)]
    $app,
    
    [Parameter(Mandatory)]
    $souscriptionId,

    [Parameter(Mandatory)]
    $diskAttach    
)

# Variables communes
#$resourceGroup = "RGO01-" + $env
$resourceGroup = "RG-PROD01"
$location = "francecentral"
$vmSize = "Standard_B2ms"
$vnetName = "VNE01-" + $env + "-INF01"
$subnetName = "SUB07-" + $env + "-RMQ01"
$nsgName = "NSG01-" + $env + "-RMQ01"
$osDiskSize = "127"
$osDiskType = "Standard_LRS"
$pubName = "MicrosoftWindowsServer"
$offerName = "WindowsServer"
$skuName = "2019-Datacenter"
$dataDiskSize = "64"
$dataDiskType = "Standard_LRS"
$avSetName = "AVS-" + $env + "-RMQ01"
$kv = "testkvrmq"

<#
le vnet et le subnet sont deja créés
on va dans le portail azure pour recuperer le bon nom par environnement
on le renseigne dans les variables
#>

#az login
az account set -s $souscriptionId

# creation availability set
az vm availability-set create -n $avSetName -g $resourceGroup --location $location --platform-fault-domain-count 2 --platform-update-domain-count 5

# creation nsg
az network nsg create --resource-group $resourceGroup --location $location --name $nsgName 

# creation regle nsg
az network nsg rule create --resource-group $resourceGroup --name tse --nsg-name $nsgName --protocol Tcp `
    --direction Inbound --priority 1000 --source-address-prefixes * --source-port-ranges * --destination-address-prefixes * `
    --destination-port-range 3389 --access Allow

$image = $pubName + ":" + $offerName + ":" + $skuName + ":latest" 

# le key vault a ete créé en amont avec les 2 secrets et il est dans la meme souscription mais dans un autre ressource group
$mdp = az keyvault secret show --name mdpvm --vault-name $kv --query value --output tsv
$login = az keyvault secret show --name login --vault-name $kv --query value --output tsv

$auth = "password"

for($i=1;$i -lt 4; $i++)
{
  # variables pour chaque vm
  # $computerName = "APRE03VWRMQ01"
  $computerName = "A"+ $env + "V" + $os + $app + "0" + $i
  $vmName = "VMA01-" + $env + "-" + $computerName
  $nicName = "NIC01-" + $env + "-" + $computerName
  $osDiskName = "DKO01-" + $env + "-" + $computerName
  $dataDiskName = "DKD01-" + $env + "-" + $computerName

  # creation de la nic
  az network nic create --name $nicName --resource-group $resourceGroup `
  --vnet-name $vnetName --subnet $subnetName --network-security-group $nsgName

  # creation du disk data
  az disk create -g $resourceGroup -n $dataDiskName --size-gb $dataDiskSize --sku $dataDiskType --image-reference-lun 0

  # creer une vm avec un disk os vierge
  az vm create -n $vmName -g $resourceGroup --admin-password $mdp --admin-username $login --authentication-type $auth --computer-name $computerName `
  --os-disk-caching ReadWrite --os-disk-name $osDiskName --os-disk-size-gb $osDiskSize --image $image --storage-sku $osDiskType --size $vmSize --attach-data-disks $dataDiskName --nics $nicName --availability-set $avSetName
  
}


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
