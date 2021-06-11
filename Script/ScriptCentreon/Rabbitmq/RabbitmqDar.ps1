param(
    [Parameter(Mandatory)]
    $username,

    [Parameter(Mandatory)]
    $password,

    [Parameter(Mandatory)]
    $ipHost,

    [Parameter(Mandatory)]
    $env,

    [Parameter(Mandatory)]
    $warningRam,

    [Parameter(Mandatory)]
    $criticalRam,

    [Parameter(Mandatory)]
    $warningMessage,

    [Parameter(Mandatory)]
    $criticalMessage   
)

function CheckRam($ram, $name)
{
  if($ram -gt $criticalRam) 
  {
    WriteInFile $locationFile "critical" "Trop de memoire utilisée sur la file $name taille $ram MB"  
  } 
  else 
  {
    if ($ram -gt $warningRam)
    {
      WriteInFile $locationFile "warning" "Beaucoup de memoire utilisée sur la file $name taille $ram MB"  
    }
  }
}

function CheckNbMessage($nbMessage, $name)
{
   
  if($nbMessage -gt $criticalMessage) 
  {
    WriteInFile $locationFile "critical" "Trop de messages sur la file $name nb $nbMessage" 
  } 
  else 
  {
    if ($nbMessage -gt $warningMessage)
    {
      WriteInFile $locationFile "warning" "Beaucoup de messages sur la file $name nb $nbMessage" 
    }
  }
}

function CheckNbConsumer($nbConsumer, $name)
{
    if($nbConsumer -eq 0)
    {
      WriteInFile $locationFile "critical" "Aucun consommateur sur la file $name"
    }
}

function WriteInFile($file, $level, $message)
{
    Add-Content $file "$level : $message"
    Exit
}

$env = $env.ToUpper();
$centreonNameFile = "Log"+$env+"Rabbitmq.txt"
$locationFile = "$PSScriptRoot\$centreonNameFile"

if(Test-Path $locationFile -PathType Leaf)
{
    Clear-Content $locationFile
}
else
{
    $centreonFile = New-Item -type file $locationFile -Force
}

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))

#region node
try
{
    $healtNode = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Uri ("http://{0}:15672/api/healthchecks/node" -f $ipHost)
    
}
catch
{
    WriteInFile $locationFile "critical" "$ipHost $_"
}

if($healtNode.status -notmatch "ok")
{
    WriteInFile $locationFile "critical" "$nodeHealt.status"
}
#endregion    

#region queue
$listQueue = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Uri ("http://{0}:15672/api/queues" -f $ipHost)

if ($listQueue.Count -eq 0)
{
   WriteInFile $locationFile "critical" "aucune file presente" 
}

Foreach($queue in $listQueue) 
{ 
  $nameQueue = $queue.name  
  $memoryQueue = [math]::Round($queue.memory / 1MB, 2)
  CheckRam $memoryQueue $nameQueue # verifier taille memoire de la file

  $memoryMessageQueue = [math]::Round($queue.message_bytes_ram / 1MB, 2)
  CheckRam $memoryMessageQueue $nameQueue # verifier taille memoire des messages

  $nbMessages = $queue.messages
  CheckNbMessage $nbMessages $nameQueue # verifier nombre de messages
  
  $nbReadyMessages = $queue.messages_ready
  CheckNbMessage $nbReadyMessages $nameQueue # verifier nombre de messages prets

  $nbUnAckMessages = $queue.messages_unacknowledged
  CheckNbMessage $nbAckMessages $nameQueue #  verifier nombre de messages non reconnu

  if($queue.name -notmatch 'dlq')
  {
    $nbConsumersQueue = $queue.consumers
    CheckNbConsumer $nbConsumersQueue $nameQueue # verifier si au moins 1 conso sur les files *IN
  }
}
#endregion
WriteInFile $locationFile "OK" "tout va bien" 

