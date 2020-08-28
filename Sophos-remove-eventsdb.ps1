 <#
Name:           Sophos-renew-events-db.ps1
Usage:          Run from ISE
Date:           1.0 - 03-08-2020 Chris Vahl - Initial Release
Description:
    If in Sophos Central a server stays forever in Medium Health state because of "Malware or potentially unwanted applications in quarantine"
    then you can only clear that by renewing the events-database.
    Fill in the machine names in $server  and disable the Tamper Protection in Sophos Central upfront.
    As a check, the timestamp of all events.db are reported. If any has a timestamp before executing the script, something went wrong.
    Afterwards, ENABLE the Tamper Protection!!
#>

$server="server1","server2","etc"

$scriptToExecute={
$path="c:\programdata\sophos\health\event store\database\"
$service="Sophos Health Service"
Stop-Service $service
del "$path\events.db.old"
Start-Service $service
$check=dir $path
Write-Output $check
}

$report = Invoke-Command -ComputerName $server -ScriptBlock $scriptToExecute 4>&1
Write-Host "-----Timestamp of the events.db-----"
$report
