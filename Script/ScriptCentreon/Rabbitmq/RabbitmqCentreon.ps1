param(
    [Parameter(Mandatory)]
    $env
)

$fileName = "E:\EXPAutomator\EXPLOIT\Fichiers\Log" +$env + "Rabbitmq.txt"


try
{
    $infoFile = Get-Content $fileName 
    Write-Output $infoFile
    if ($infoFile | Where-Object { $_.Contains("critical") })
    {
        Exit 2
    }
    else
    {
        if ($infoFile | Where-Object { $_.Contains("warning") })
        {   
            Exit 1
        }
    }

    Exit 0
}
catch
{
    Write-Output $_
    Exit 2
}


