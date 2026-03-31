[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$TargetIP,

    [Parameter(Mandatory=$true)]
    [string]$Hostname,

    [Parameter(Mandatory=$true)]
    [string]$NicName,

    [Parameter(Mandatory=$true)]
    [string]$VNetName,

    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup
)

function Write-Section {
    param ([string]$Title)

    Write-Host ""
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host " $Title" -ForegroundColor Cyan
    Write-Host "===================================="
}

# Store results
$results = @()

# Timestamp for report
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$reportFile = "AzureNetworkDiagnostics-$timestamp.json"

# ===== Connectivity =====
Write-Section "Connectivity Test"

try {
    .\connectivity\Test-VNetConnectivity.ps1 -TargetIP $TargetIP
    $results += [PSCustomObject]@{
        Test      = "Connectivity"
        Status    = "Completed"
        Timestamp = Get-Date
    }
}
catch {
    $results += [PSCustomObject]@{
        Test      = "Connectivity"
        Status    = "Failed"
        Timestamp = Get-Date
    }
}

# ===== DNS =====
Write-Section "DNS Test"

try {
    .\dns\Test-AzureDNS.ps1 -Hostname $Hostname
    $results += [PSCustomObject]@{
        Test      = "DNS"
        Status    = "Completed"
        Timestamp = Get-Date
    }
}
catch {
    $results += [PSCustomObject]@{
        Test      = "DNS"
        Status    = "Failed"
        Timestamp = Get-Date
    }
}

# ===== Routing =====
Write-Section "Route Analysis"

try {
    .\routing\Get-AzureEffectiveRoutes.ps1 -NicName $NicName -ResourceGroup $ResourceGroup
    $results += [PSCustomObject]@{
        Test      = "Routing"
        Status    = "Completed"
        Timestamp = Get-Date
    }
}
catch {
    $results += [PSCustomObject]@{
        Test      = "Routing"
        Status    = "Failed"
        Timestamp = Get-Date
    }
}

# ===== Peering =====
Write-Section "VNet Peering"

try {
    .\peering\Check-VNetPeering.ps1 -VNetName $VNetName -ResourceGroup $ResourceGroup
    $results += [PSCustomObject]@{
        Test      = "Peering"
        Status    = "Completed"
        Timestamp = Get-Date
    }
}
catch {
    $results += [PSCustomObject]@{
        Test      = "Peering"
        Status    = "Failed"
        Timestamp = Get-Date
    }
}

# ===== Summary =====
Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host " Diagnostic Summary" -ForegroundColor Green
Write-Host "===================================="

$results | Format-Table -AutoSize

# ===== Export to JSON =====
$results | ConvertTo-Json -Depth 3 | Out-File $reportFile

Write-Host ""
Write-Host "Report exported to: $reportFile" -ForegroundColor Yellow