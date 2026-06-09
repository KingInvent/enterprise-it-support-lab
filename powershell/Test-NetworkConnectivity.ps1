<#
.SYNOPSIS
Runs network connectivity diagnostics for BlancoTech Solutions.

.DESCRIPTION
Performs common IT support network troubleshooting checks:
- Local IP configuration
- Default gateway detection
- DNS server detection
- Ping test
- DNS resolution test
- TCP port connectivity test
- CSV and HTML report export
- Logging to C:\Logs\NetworkConnectivityLog.txt

.PARAMETER Target
Hostname or IP address to test. Default: blancotech.local

.PARAMETER Port
TCP port to test. Default: 53

.PARAMETER OutputPath
Folder where CSV and HTML reports will be saved. Default: C:\Reports

.EXAMPLE
.\Test-NetworkConnectivity.ps1

.EXAMPLE
.\Test-NetworkConnectivity.ps1 -Target "blancotech.local" -Port 53

.EXAMPLE
.\Test-NetworkConnectivity.ps1 -Target "vm-bt-dc01.blancotech.local" -Port 3389

.NOTES
Author: Darko Blancovich
Purpose: IT portfolio lab — BlancoTech Solutions network troubleshooting automation
Requires: PowerShell 5.1+
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$Target = "blancotech.local",

    [Parameter(Mandatory = $false)]
    [int]$Port = 53,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "C:\Reports"
)

# -----------------------------
# Configuration
# -----------------------------

$LogDirectory = "C:\Logs"
$LogFile = "$LogDirectory\NetworkConnectivityLog.txt"

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$CsvFile = "$OutputPath\NetworkConnectivity_$Timestamp.csv"
$HtmlFile = "$OutputPath\NetworkConnectivity_$Timestamp.html"

# -----------------------------
# Logging
# -----------------------------

function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("INFO", "SUCCESS", "WARNING", "ERROR")]
        [string]$Level = "INFO"
    )

    $CurrentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Entry = "$CurrentTime [$Level] $Message"

    switch ($Level) {
        "SUCCESS" { Write-Host $Entry -ForegroundColor Green }
        "WARNING" { Write-Host $Entry -ForegroundColor Yellow }
        "ERROR"   { Write-Host $Entry -ForegroundColor Red }
        default   { Write-Host $Entry }
    }

    Add-Content -Path $LogFile -Value $Entry
}

# -----------------------------
# Preparation
# -----------------------------

if (-not (Test-Path $LogDirectory)) {
    New-Item -Path $LogDirectory -ItemType Directory -Force | Out-Null
}

if (-not (Test-Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
}

Write-Log "Starting network connectivity diagnostics. Target: $Target Port: $Port" "INFO"

# -----------------------------
# Local Network Information
# -----------------------------

try {
    $IPConfig = Get-NetIPConfiguration |
        Where-Object { $_.IPv4Address -and $_.NetAdapter.Status -eq "Up" } |
        Select-Object -First 1

    $LocalIPv4 = if ($IPConfig.IPv4Address.IPAddress) { $IPConfig.IPv4Address.IPAddress } else { "Not found" }
    $InterfaceAlias = if ($IPConfig.InterfaceAlias) { $IPConfig.InterfaceAlias } else { "Not found" }
    $DefaultGateway = if ($IPConfig.IPv4DefaultGateway.NextHop) { $IPConfig.IPv4DefaultGateway.NextHop } else { "Not found" }
    $DnsServers = if ($IPConfig.DNSServer.ServerAddresses) { $IPConfig.DNSServer.ServerAddresses -join ", " } else { "Not found" }

    Write-Log "Collected local IP configuration." "SUCCESS"
}
catch {
    $LocalIPv4 = "Lookup failed"
    $InterfaceAlias = "Lookup failed"
    $DefaultGateway = "Lookup failed"
    $DnsServers = "Lookup failed"

    Write-Log "Failed to collect local IP configuration. Error: $($_.Exception.Message)" "ERROR"
}

# -----------------------------
# Ping Test
# -----------------------------

try {
    $PingSuccess = Test-Connection -ComputerName $Target -Count 2 -Quiet -ErrorAction Stop

    if ($PingSuccess) {
        $PingResult = "Success"
        Write-Log "Ping test successful for $Target." "SUCCESS"
    }
    else {
        $PingResult = "Failed"
        Write-Log "Ping test failed for $Target." "WARNING"
    }
}
catch {
    $PingResult = "Failed"
    Write-Log "Ping test failed for $Target. Error: $($_.Exception.Message)" "WARNING"
}

# -----------------------------
# DNS Resolution Test
# -----------------------------

try {
    $DnsResult = Resolve-DnsName -Name $Target -ErrorAction Stop
    $ResolvedAddresses = ($DnsResult | Where-Object { $_.IPAddress } | Select-Object -ExpandProperty IPAddress) -join ", "

    if (-not $ResolvedAddresses) {
        $ResolvedAddresses = "Resolved, but no IP returned"
    }

    $DnsStatus = "Success"
    Write-Log "DNS resolution successful for $Target. Result: $ResolvedAddresses" "SUCCESS"
}
catch {
    $DnsStatus = "Failed"
    $ResolvedAddresses = "N/A"
    Write-Log "DNS resolution failed for $Target. Error: $($_.Exception.Message)" "WARNING"
}

# -----------------------------
# TCP Port Test
# -----------------------------

try {
    $TcpTest = Test-NetConnection -ComputerName $Target -Port $Port -WarningAction SilentlyContinue

    if ($TcpTest.TcpTestSucceeded) {
        $TcpStatus = "Success"
        Write-Log "TCP port test successful. Target: $Target Port: $Port" "SUCCESS"
    }
    else {
        $TcpStatus = "Failed"
        Write-Log "TCP port test failed. Target: $Target Port: $Port" "WARNING"
    }

    $RemoteAddress = if ($TcpTest.RemoteAddress) { $TcpTest.RemoteAddress } else { "N/A" }
}
catch {
    $TcpStatus = "Failed"
    $RemoteAddress = "N/A"
    Write-Log "TCP port test failed. Error: $($_.Exception.Message)" "WARNING"
}

# -----------------------------
# Gateway Ping Test
# -----------------------------

if ($DefaultGateway -ne "Not found" -and $DefaultGateway -ne "Lookup failed") {
    try {
        $GatewayPingSuccess = Test-Connection -ComputerName $DefaultGateway -Count 2 -Quiet -ErrorAction Stop

        if ($GatewayPingSuccess) {
            $GatewayPingResult = "Success"
            Write-Log "Default gateway ping successful: $DefaultGateway" "SUCCESS"
        }
        else {
            $GatewayPingResult = "Failed"
            Write-Log "Default gateway ping failed: $DefaultGateway" "WARNING"
        }
    }
    catch {
        $GatewayPingResult = "Failed"
        Write-Log "Default gateway ping failed. Error: $($_.Exception.Message)" "WARNING"
    }
}
else {
    $GatewayPingResult = "Skipped"
    Write-Log "Default gateway ping skipped because no gateway was found." "WARNING"
}

# -----------------------------
# Build Report
# -----------------------------

$Report = @(
    [PSCustomObject]@{
        CheckName = "Local IPv4 Address"
        Target = $env:COMPUTERNAME
        Result = $LocalIPv4
        Status = if ($LocalIPv4 -notin @("Not found", "Lookup failed")) { "Success" } else { "Warning" }
    }
    [PSCustomObject]@{
        CheckName = "Active Interface"
        Target = $env:COMPUTERNAME
        Result = $InterfaceAlias
        Status = if ($InterfaceAlias -notin @("Not found", "Lookup failed")) { "Success" } else { "Warning" }
    }
    [PSCustomObject]@{
        CheckName = "Default Gateway"
        Target = $env:COMPUTERNAME
        Result = $DefaultGateway
        Status = if ($DefaultGateway -notin @("Not found", "Lookup failed")) { "Success" } else { "Warning" }
    }
    [PSCustomObject]@{
        CheckName = "DNS Servers"
        Target = $env:COMPUTERNAME
        Result = $DnsServers
        Status = if ($DnsServers -notin @("Not found", "Lookup failed")) { "Success" } else { "Warning" }
    }
    [PSCustomObject]@{
        CheckName = "Ping Target"
        Target = $Target
        Result = $PingResult
        Status = $PingResult
    }
    [PSCustomObject]@{
        CheckName = "DNS Resolution"
        Target = $Target
        Result = $ResolvedAddresses
        Status = $DnsStatus
    }
    [PSCustomObject]@{
        CheckName = "TCP Port Test"
        Target = "$Target`:$Port"
        Result = "RemoteAddress: $RemoteAddress"
        Status = $TcpStatus
    }
    [PSCustomObject]@{
        CheckName = "Default Gateway Ping"
        Target = $DefaultGateway
        Result = $GatewayPingResult
        Status = $GatewayPingResult
    }
)

# -----------------------------
# Export CSV
# -----------------------------

try {
    $Report | Export-Csv -Path $CsvFile -NoTypeInformation -Encoding UTF8
    Write-Log "CSV report saved to $CsvFile." "SUCCESS"
}
catch {
    Write-Log "Failed to export CSV report. Error: $($_.Exception.Message)" "ERROR"
}

# -----------------------------
# Export HTML
# -----------------------------

$HtmlHead = @"
<style>
    body {
        font-family: Arial, sans-serif;
        font-size: 13px;
        color: #222;
    }
    h1, h2 {
        color: #333;
    }
    table {
        border-collapse: collapse;
        width: 100%;
        margin-top: 12px;
    }
    th {
        background-color: #2F5597;
        color: white;
        padding: 8px;
        text-align: left;
    }
    td {
        padding: 6px;
        border: 1px solid #ddd;
    }
    tr:nth-child(even) {
        background-color: #f2f2f2;
    }
</style>
"@

$HtmlPreContent = @"
<h1>BlancoTech Solutions — Network Connectivity Report</h1>
<p><strong>Generated:</strong> $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
<p><strong>Computer:</strong> $env:COMPUTERNAME</p>
<p><strong>Target:</strong> $Target</p>
<p><strong>TCP Port:</strong> $Port</p>

<h2>Diagnostic Results</h2>
"@

try {
    $Report |
        ConvertTo-Html -Head $HtmlHead -PreContent $HtmlPreContent |
        Out-File -FilePath $HtmlFile -Encoding UTF8

    Write-Log "HTML report saved to $HtmlFile." "SUCCESS"
}
catch {
    Write-Log "Failed to export HTML report. Error: $($_.Exception.Message)" "ERROR"
}

# -----------------------------
# Console Summary
# -----------------------------

Write-Host ""
Write-Host "=== Network Connectivity Summary ===" -ForegroundColor Cyan
Write-Host "Computer:              $env:COMPUTERNAME"
Write-Host "Target:                $Target"
Write-Host "Port tested:           $Port"
Write-Host "Local IPv4:            $LocalIPv4"
Write-Host "Interface:             $InterfaceAlias"
Write-Host "Default gateway:       $DefaultGateway"
Write-Host "DNS servers:           $DnsServers"
Write-Host "Ping target:           $PingResult"
Write-Host "DNS resolution:        $DnsStatus"
Write-Host "Resolved address(es):  $ResolvedAddresses"
Write-Host "TCP port test:         $TcpStatus"
Write-Host "Gateway ping:          $GatewayPingResult"
Write-Host "CSV report:            $CsvFile"
Write-Host "HTML report:           $HtmlFile"
Write-Host "Log file:              $LogFile"
Write-Host ""

$Report | Format-Table CheckName, Target, Status, Result -AutoSize

Write-Log "Completed network connectivity diagnostics for $Target." "SUCCESS"
