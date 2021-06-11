
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
$resourceGroup = "HaCluster"
$location = "francecentral"
$vmSize = "Standard_B2s"
$vnetName = "VNE01-" + $env + "-INF01"
$subnetName = "SUB07-" + $env + "-RMQ01"
$nsgName = "NSG01-" + $env + "-RMQ01"
$osDiskSize = "127"
$osDiskType = "Standard_LRS"
$pubName = "RedHat"
$offerName = "RHEL"
$skuName = "7.8"
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

# creation nsg
az network nsg create --resource-group $resourceGroup --location $location --name $nsgName 

# creation regle nsg
az network nsg rule create --resource-group $resourceGroup --name tse --nsg-name $nsgName --protocol Tcp `
    --direction Inbound --priority 1000 --source-address-prefixes * --source-port-ranges * --destination-address-prefixes * `
    --destination-port-range 3389 --access Allow

$image = $pubName + ":" + $offerName + ":" + $skuName + ":latest" 

$mdp = "Vendome41100.*"
$login = "administrateur"
$auth = "password"

for($i=1;$i -lt 8; $i++)
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
  #az disk create -g $resourceGroup -n $dataDiskName --size-gb $dataDiskSize --sku $dataDiskType --image-reference-lun 0

  # creer une vm avec un disk os vierge
  az vm create -n $vmName -g $resourceGroup --admin-password $mdp --admin-username $login --authentication-type $auth --computer-name $computerName `
  --os-disk-caching ReadWrite --os-disk-name $osDiskName --os-disk-size-gb $osDiskSize --image $image --storage-sku $osDiskType --size $vmSize --nics $nicName
  
}



