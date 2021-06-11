# creation d'une fonction

```console
Function Set-Auth {
  # permet d'avoir tous les parametres d'error pour une fonction
  [CmdLetBinding()]
  Param (
    [string]$souscriptionId
  )

  az login
  az account set -s $souscriptionId

}
```

# afficher aide d'une fonction

Lorsque l'on execute la fonction, elle est chargée en memoire

```console
get-help Set-Auth

NOM
    Set-Auth

SYNTAXE
    Set-Auth [[-souscriptionId] <string>]


ALIAS
    Aucun(e)


REMARQUES
    Aucun(e)

```

# dot sourcing

charge en memoire le code sans avoir besoin de l'executer

se placer dans le repertoire du script

```console
. .\auth.ps1
```

# creation d'un module

psm1 au lieu de ps1

permet de regrouper plusieurs fonctions dans un meme module
Possibilité de charger automatiquement au lancement de Powershell 
C:\Program Files\WindowsPowerShell\Modules si on veut que ce soit accessible pour toutes les sessions
variable PSModulePath (on peut donc creer un repertoire precis ou mettre tout nos modules et l'ajouter dans le path si on veut)

```console
cd env:
ls 

PSModulePath                   C:\Users\jbarbaro\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules;C:\Program Files (x86)...

```

Fichier psd1, module manifeste. Fichier pour avoir plus d'info sur le module, version de lhote, framework etc...

## creer un nouveau module

se rendre dans C:\Program Files\WindowsPowerShell\Modules

creer le repertoire AutAzure
il faut que le nom du module soit le meme que celui du repertoire.
Donc enregistrer AuthAzure.psm1

# parametres avancés

permet de mettre de l'aide sur un parametre. il faut taper !? pour afficher l'aide

```console

Param(
  [Parameter(Mandatory,HelpMessage='Provide a computer name')]
)

```

validation

```console

# Verifier la longueur d'un champ 
Function demo-validation {
[CmdLetBinding()]
Param(
[ValidateLength (1,8)]
[string]$item
)
}

# Verifier les bornes pour un entier
Function demo-validation {
[CmdLetBinding()]
Param(
[ValidateRange (30,40)]
[Int]$age
)
}

# Verifier qu'on puisse avoir entre 1 et 4 valeurs
Function demo-validation {
[CmdLetBinding()]
Param(
[ValidateCount (1,4)]
[string[]]$item
)
}

Function demo-validation {
[CmdLetBinding()]
Param(
[ValidateSET('janvier','fevrier', 'mars')]
[string[]]$item
)
}

Function demo-validation {
[CmdLetBinding()]
Param(
[ValidatePattern('^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')]        
[string[]]$item
)
}

```

# foreach

```console

Function Get-Pcinfo {
  [CmdLetBinding()]
  Param(
    [Parameter (Mandatory
                HelpMessage='Merci de taper un nom de serveur valide')]
    [Alias ('HostName')]
    [ValidateSET('node1, node2, node3')]
    [string]$computerName

  )

  foreach ($pc in $computerName) {
    Get-CimInstance -computerName $computerName -className win32_operatingsystem
  } # fin de foreach
    
}

```

# gestion des erreurs

$ErrorActionPreference par defaut Continue
Silentlycontinue : n'affiche pas l'erreur est en silencieux
inquire : demande si on doit continuer
Stop : il s'arrete direct et a mettre pour le try catch

capturer lerreur la plus recente

$error[0]

-ErrorVariable

logger tous les messages d'erreur dans un fichier de log out-file

# alias basic

Dir
del
Pusd
Pwd
Cls

# commandes

Get-Help
Get-Command
Set-wmiObject
Move-Adcomputer
Read-host

# operateur logique

-eq equal -ceq(sensible à la casse) -ieq (insensible à la casse)
-ne not equal -cne -ine
-gt greather than -cgt -igt
-ge greather or equal -cge -ige
-lt less then -clt -ilt 
-le less or equal -cle -ile

# article a lire

https://learn-powershell.net/articles/

https://learn-powershell.net/2014/02/04/using-powershell-parameter-validation-to-make-your-day-easier/

