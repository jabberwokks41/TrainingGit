# Introduction

une extension custom Azure, permet de lancer un script une fois généralement sur une machine cible.

Dans notre cas, nous pourrions preparer un script ps1 qui permettrait de faire les differentes taches de configuration de la vm une fois celle ci créée.

# Creation d'une extension azure

la création se fera en 3 etapes :

1) creer le script powershell contenant toutes les taches à effectuer sur la vm
2) stocker le script ps1 dans un storage account sous forme de blob donc il faut creer un conteneur de blob aussi. La vm va devoir acces au storage account donc on 
peut mettre l'acces au conteneur en "Container (anonymous read access for containers and blobs)" afiin de permettre le telechargement du fichier par la vm
3) faire le script de l'extension sur la vm

1) example du fichier powershell testVmExtension.ps1

```console
New-NetFirewallRule -DisplayName “rabbitmq” -Direction Inbound –Protocol TCP –LocalPort 5672 -Action allow
```

2) dans la subscription gold 2021 tenant EIC, creation d'un storage account testextensionpwshell
creation d'un conteneur vmextension
upload du fichier testVmExtension.ps1

3) example d'un script powershell pour creer une custom extension en utilisant le script du storage account

```console
$settings = '{\"fileUris\": [\"https://testextensionpwshell.blob.core.windows.net/vmextension/testVmExtension.ps1\"], \"commandToExecute\": \"powershell.exe -ExecutionPolicy Unrestricted -File testVmExtension.ps1 \"}'


az vm extension set --resource-group $resourceGroup --vm-name $vmName --name "CustomScriptExtension" --publisher "Microsoft.Compute" --version "1.10" --settings $settings
```



# les logs sur le traitement de l'extension seront ici :

C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension

# le fichier ps1 telechargé sera ici :

C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.9\Downloads\0

# page officiel microsoft

https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows