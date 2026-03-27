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

# ===== Logging =====
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$timestamp [$Level] $Message"
}

Write-Host "====================================" -ForegroundColor Cyan
Write-Host " Azure Network Diagnostics Toolkit" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

Write-Log "Starting full network diagnostics"

# ===== Connectivity Test =====
Write-Host ""
Write-Host "1. Connectivity Test" -ForegroundColor Yellow

.\connectivity\Test-VNetConnectivity.ps1 -TargetIP $TargetIP

# ===== DNS Test =====
Write-Host ""
Write-Host "2. DNS Resolution Test" -ForegroundColor Yellow

.\dns\Test-AzureDNS.ps1 -Hostname $Hostname

# ===== Route Analysis =====
Write-Host ""
Write-Host "3. Route Analysis" -ForegroundColor Yellow

.\routing\Get-AzureEffectiveRoutes.ps1 -NicName $NicName -ResourceGroup $ResourceGroup

# ===== VNet Peering =====
Write-Host ""
Write-Host "4. VNet Peering Check" -ForegroundColor Yellow

.\peering\Check-VNetPeering.ps1 -VNetName $VNetName -ResourceGroup $ResourceGroup

Write-Host ""
Write-Log "Diagnostics completed"