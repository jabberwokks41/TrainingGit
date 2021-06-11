Function SetSubscription {
   <#
  .SYNOPSIS
  Cette fonction permet le positionnement
  sur la souscription souhait�e
  .DESCRIPTION
  Pour utiliser cette fonction, il faut avoir un compte azure ayant les droits sur
  la souscription cible
  .PARAMETER souscriptionId
  Merci de taper une souscription dont le compte a acces
  .EXEMPLE
  Set-Auth -souscriptionId XXX-XXX-XXXX-XX
  #>
  
  # permet d'avoir tous les parametres d'error pour une fonction
  [CmdLetBinding()]
  Param (
    [Parameter (Mandatory, 
                HelpMessage = 'Merci de saisir la souscription') 
    ]
    [string]$souscriptionId
  )

  az account set -s $souscriptionId

}
