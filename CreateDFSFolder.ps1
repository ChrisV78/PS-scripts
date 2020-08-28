<#-----------------------------------------------------------------------------
Name:           CreateDFSFolder.ps1
Description:    Script to create a DFS Folder for a FSx share on AWS and puts a description on the computerobject

Usage:          .\CreateDFSFolder.ps1 -Env "dev" -dnsname "AWS provided dns name" -Folder "Foldername"
Date:           1.0 - 12-06-2020 Chris Vahl - Initial Release

dev or prod: $Env="dev"
Name provided by AWS FSx: $dnsname
name of the share visible in DFS: $Folder

#>

param (
    [Parameter(Mandatory = $True)]
    [string]$env,
    [Parameter(Mandatory = $True)]
    [string]$dnsname,
    [Parameter(Mandatory = $True)]
    [string]$Folder
)

#DFS domain
$Domain = "x.x"

try {
    Get-DfsnFolderTarget -Path "\\$Domain\$env\$folder" -ErrorAction Stop
}
catch {
    Write-Host "Path not found. Clear to proceed" -ForegroundColor Green
}

New-DfsnFolder -Path "\\$Domain\$env\$folder" -TargetPath "\\$dnsname\Share"  -Description "$folder" -EnableInsiteReferrals $false

# Check that folder now exists:
$dfsname = Get-DfsnFolderTarget -Path "\\$Domain\$env\$folder"
Write-Host $dfsname -ForegroundColor Green

#Fil description on computer object
Get-adcomputer -Filter "DNSHostName -like '$dnsname'" | Set-ADComputer -Description "AWS FSx $env $folder"

