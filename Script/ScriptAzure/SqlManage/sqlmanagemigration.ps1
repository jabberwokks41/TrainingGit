
param(
    [Parameter(Mandatory)]
    $env,

    [Parameter(Mandatory)]
    $souscriptionIdNew,
    
    [Parameter(Mandatory)]
    $souscriptionIdOld,

    [Parameter(Mandatory)]
    $resourceGroupOld,

    [Parameter(Mandatory)]
    $slqServerNameOld,

    [Parameter(Mandatory)]
    $sqlBddNameOld
)

$env = $env.ToUpper()

# Variables communes
$resourceGroup = "RGO01-" + $env
$kv = "KVA01-" + $env
$vnetName = "VNE01-" + $env +"-INF01"
$location = "francecentral"

$subnetArrName = "SUB01-" + $env + "-ARR01"
$subnetArrip = "172.24.1.0"
$subnetArrPrefix = "172.24.1.0/24"
$subnetArrRuleName = "VNR01-" + $env + "-SUB01"
[string[]]$arrTab = $subnetArrName, $subnetArrip, $subnetArrPrefix, $subnetArrRuleName

$subnetDefName = "SUB02-" + $env + "-DEF01"
$subnetDefip = "172.24.2.0"
$subnetDefPrefix = "172.24.2.0/24"
$subnetDefRuleName = "VNR01-" + $env + "-SUB02"
[string[]]$defTab = $subnetDefName, $subnetDefip, $subnetDefPrefix, $subnetDefRuleName

$subnetAutName = "SUB05-" + $env + "-AUT01"
$subnetAutip = "172.24.5.0"
$subnetAutPrefix = "172.24.5.0/24"
$subnetAutRuleName = "VNR01-" + $env + "-SUB05"
[string[]]$autTab = $subnetAutName, $subnetAutip, $subnetAutPrefix, $subnetAutRuleName

$subnetAppName = "SUB06-" + $env + "-APP01"
$subnetAppip = "172.24.6.0"
$subnetAppPrefix = "172.24.6.0/24"
$subnetAppRuleName = "VNR01-" + $env + "-SUB06"
[string[]]$appTab = $subnetAppName, $subnetAppip, $subnetAppPrefix, $subnetAppRuleName

$subnetRmqName = "SUB07-" + $env + "-RMQ01"
$subnetRmqip = "172.24.7.0"
$subnetRmqPrefix = "172.24.7.0/24"
$subnetRmqRuleName = "VNR01-" + $env + "-SUB07"
[string[]]$rmqTab = $subnetRmqName, $subnetRmqip, $subnetRmqPrefix, $subnetRmqRuleName

$subnetAksName = "SUB10-" + $env + "-AKS01"
$subnetAksip = "172.24.10.0"
$subnetAksPrefix = "172.24.10.0/24"
$subnetAksRuleName = "VNR01-" + $env + "-SUB10"
[string[]]$aksTab = $subnetAksName, $subnetAksip, $subnetAksPrefix, $subnetAksRuleName

az login

# module créé et mis dans C:\Program Files\WindowsPowerShell\Modules\SetSubAzure
# on se place sur la nouvelle souscription pour creer les ressources
SetSubscriptionAzure $souscriptionIdNew

# Keyvault dans le resourcegroup avec les secrets sql
$mdp = az keyvault secret show --name mdpSql --vault-name $kv --query value --output tsv
# pour ne pas avoir d'erreur avec les caracteres speciaux, il faut faire 2 echappements pour Az et PowerShell
$mdp = '\"'+ $mdp+'\"'
$login = az keyvault secret show --name loginSql --vault-name $kv --query value --output tsv

# creation des subnets si besoin ARR, DEF, AUT, APP, RMQ, AKS 
[string[][]]$apps = $arrTab, $defTab, $autTab, $appTab, $rmqTab, $aksTab

foreach ($item in $apps) {
  CheckAndCreateSubnet $resourceGroup $vnetName $item[0] $item[1] $item[2]
}

# creation du serveur sql bql01-dev01

$slqServerName = "bql01-" + $env.ToLower() 

az sql server create -l $location -g $resourceGroup -n $slqServerName -u $login -p $mdp 

# creation des regles firewall ip EIC et Allow Azure services à yes pour l'import
$ruleNameEic = "Acces"
$ipStart = "1111"
$ipEnd = "2222"
$ruleNameAllow = "all"
az sql server firewall-rule create -g $resourceGroup -s $slqServerName -n $ruleNameEic --start-ip-address $ipStart --end-ip-address $ipEnd

az sql server firewall-rule create -g $resourceGroup -s $slqServerName -n $ruleNameAllow --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# creation des regles vnet firewall

foreach ($item in $apps) {
  az sql server vnet-rule create --server $slqServerName --name $item[3] -g $resourceGroup --subnet $item[0] --vnet-name $vnetName
}

# creation de la base sql vierge

$sqlBddName = "sdb01-" + $env.ToLower() + "-mas01"

az sql db create -g $resourceGroup -s $slqServerName -n $sqlBddName -f Gen5 -c 2

# voir backup ??
#az sql db create -g mygroup -s myserver -n mydb -e GeneralPurpose --backup-storage-redundancy Local 

# on se place sur l'ancienne souscription pour faire l'export
SetSubscriptionAzure $souscriptionIdOld

# RG-DEVREC, adevrecmsql01, ADEV01MBDD01
$storageUri = "https://sqlvaz5ygp7dxnqahi.blob.core.windows.net/exportbdd/"+$sqlBddNameOld+".bacpac"

az sql db export -s $slqServerNameOld -n $sqlBddNameOld -g $resourceGroupOld -p **** -u administrateur --auth-type SQL `
--storage-key *** --storage-key-type StorageAccessKey --storage-uri $storageUri

# on se place sur la nouvelle pour fair l'import
SetSubscriptionAzure $souscriptionIdNew

az sql db import -s $slqServerName -n $sqlBddName -g $resourceGroup -p $mdp -u $login --storage-key *** `
 --storage-key-type StorageAccessKey --storage-uri $storageUri
