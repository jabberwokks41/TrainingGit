Function CheckAndCreateSubnet {
  # permet d'avoir tous les parametres d'error pour une fonction
  [CmdLetBinding()]
  Param (
    [string]$rg,
    [string]$vNet,
    [string]$subnetName,
    [string]$subnetip,
    [string]$subnetprefix
  )

  <#
  $resultJson = az network vnet check-ip-address -g $rg -n $vNet --ip-address $subnetip
  $resultObject = $resultJson | ConvertFrom-Json
  if ($resultObject.Available -eq "False")
  {
    az network vnet subnet create -g $rg --vnet-name $vNet -n $subnetName --address-prefixes $subnetprefix
  }
  #>

  # permet de passer dans le catch s'il y a une exception
  # $ErrorActionPreference = 'stop'


  # "[?name=='SUB01-DEV01-ARR01'].name"
  $app = "'"+ $subnetName+"'"
  $query = "[?name=="+ $app + "].name"

  $subnetExist = az network vnet subnet list -g $rg --vnet-name $vNet --query $query --output tsv

  if($null -eq $subnetExist)
  {
    az network vnet subnet create -g $rg --vnet-name $vNet -n $subnetName --address-prefixes $subnetprefix
  }
  else
  {
    Write-Host("subnet : " + $subnetName + " déja créé")
  }
  
  # ajout du endpoint sql sur le subnet
  az network vnet subnet update -g $rg -n $subnetName --vnet-name $vNet --service-endpoints Microsoft.Sql

  <#try {
    az network vnet check-ip-address -g $rg -n $vNet --ip-address $subnetip
  }
  catch { 
    Write-Warning $Error[0]
    az network vnet subnet create -g $rg --vnet-name $vNet -n $subnetName --address-prefixes $subnetprefix
    
  }#>

}