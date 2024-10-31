Function Get-UserLocks ()
{

    param (
        [Parameter(Mandatory=$true, Position=0)]  
        [int] $Username
            )

Write-Host "Проверка блокировок пользователя:`n"
# $Username = 4928
$Pdce = (Get-AdDomain).PDCEmulator
$GweParams = @{
'Computername' = $Pdce
'LogName' = 'Security'
'FilterXPath' = "*[System[EventID=4740] and EventData[Data[@Name='TargetUserName']='$Username']]"
}
$Events = Get-WinEvent @GweParams
$Events | foreach {$_.Properties[1].value + ' ' + $_.TimeCreated}

}