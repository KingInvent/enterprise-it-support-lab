<#
.SYNOPSIS
Exports a full Active Directory user report for BlancoTech Solutions.

.DESCRIPTION
Queries Active Directory users and exports key attributes including username,
display name, department, title, enabled status, last logon, password status,
locked-out status, group count, and stale account detection.

The script outputs both CSV and HTML reports and logs all actions.

.PARAMETER OutputPath
Folder where CSV and HTML reports will be saved. Default: C:\Reports

.PARAMETER StaleThresholdDays
Number of days without logon used to classify an account as stale. Default: 90

.EXAMPLE
.\Export-ADUserReport.ps1

.EXAMPLE
.\Export-ADUserReport.ps1 -OutputPath "C:\Reports" -StaleThresholdDays 60

.NOTES
Author: Darko Blancovich
Purpose: IT portfolio lab — BlancoTech Solutions AD reporting automation
Requires: ActiveDirectory PowerShell module, Domain Admin or delegated rights
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "C:\Reports",

    [Parameter(Mandatory = $false)]
    [int]$StaleThresholdDays = 90
)

# -----------------------------
# Configuration
# -----------------------------

$SearchBase = "OU=Users,OU=BlancoTech,DC=blancotech,DC=local"
$LogDirectory = "C:\Logs"
$LogFile = "$LogDirectory\ADUserReportLog.txt"

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$CsvFile = "$OutputPath\ADUserReport_$Timestamp.csv"
$HtmlFile = "$OutputPath\ADUserReport_$Timestamp.html"
$StaleDate = (Get-Date).AddDays(-$StaleThresholdDays)

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

    Write-Host $Entry
    Add-Content -Path $LogFile -Value $Entry
}

# -----------------------------
# Preparation
# -----------------------------

try {
    Import-Module ActiveDirectory -ErrorAction Stop
}
catch {
    Write-Error "Active Directory module could not be loaded. Run this script on the domain controller or a system with RSAT installed."
    exit 1
}

if (-not (Test-Path $LogDirectory)) {
    New-Item -Path $LogDirectory -ItemType Directory -Force | Out-Null
}

if (-not (Test-Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
}

Write-Log "Starting Active Directory user report export." "INFO"

# -----------------------------
# Query AD Users
# -----------------------------

try {
    $Users = Get-ADUser -Filter * `
        -SearchBase $SearchBase `
        -Properties DisplayName, UserPrincipalName, Department, Title, Enabled, LockedOut, PasswordLastSet, PasswordNeverExpires, LastLogonDate, MemberOf, DistinguishedName |
        Select-Object `
            SamAccountName,
            DisplayName,
            UserPrincipalName,
            Department,
            Title,
            Enabled,
            LockedOut,
            PasswordNeverExpires,
            @{Name="PasswordLastSet"; Expression={
                if ($_.PasswordLastSet) { $_.PasswordLastSet.ToString("yyyy-MM-dd") } else { "Never" }
            }},
            @{Name="LastLogonDate"; Expression={
                if ($_.LastLogonDate) { $_.LastLogonDate.ToString("yyyy-MM-dd") } else { "Never" }
            }},
            @{Name="StaleAccount"; Expression={
                if (-not $_.LastLogonDate -or $_.LastLogonDate -lt $StaleDate) { "Yes" } else { "No" }
            }},
            @{Name="GroupCount"; Expression={
                if ($_.MemberOf) { $_.MemberOf.Count } else { 0 }
            }},
            DistinguishedName
}
catch {
    Write-Log "Failed to query AD users. Error: $($_.Exception.Message)" "ERROR"
    exit 1
}

if (-not $Users) {
    Write-Log "No AD users found under $SearchBase." "WARNING"
    exit 0
}

# -----------------------------
# Summary Counts
# -----------------------------

$TotalUsers = $Users.Count
$EnabledUsers = ($Users | Where-Object { $_.Enabled -eq $true }).Count
$DisabledUsers = ($Users | Where-Object { $_.Enabled -eq $false }).Count
$StaleUsers = ($Users | Where-Object { $_.StaleAccount -eq "Yes" }).Count
$LockedUsers = ($Users | Where-Object { $_.LockedOut -eq $true }).Count
$PasswordNeverExpiresUsers = ($Users | Where-Object { $_.PasswordNeverExpires -eq $true }).Count

# -----------------------------
# Export CSV
# -----------------------------

try {
    $Users | Export-Csv -Path $CsvFile -NoTypeInformation -Encoding UTF8
    Write-Log "CSV report saved to $CsvFile." "SUCCESS"
}
catch {
    Write-Log "Failed to export CSV report. Error: $($_.Exception.Message)" "ERROR"
    exit 1
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
<h1>BlancoTech Solutions — Active Directory User Report</h1>
<p><strong>Generated:</strong> $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
<p><strong>Search Base:</strong> $SearchBase</p>
<p><strong>Stale Threshold:</strong> $StaleThresholdDays days</p>

<h2>Summary</h2>
<ul>
    <li>Total users: $TotalUsers</li>
    <li>Enabled users: $EnabledUsers</li>
    <li>Disabled users: $DisabledUsers</li>
    <li>Stale users: $StaleUsers</li>
    <li>Locked-out users: $LockedUsers</li>
    <li>Password never expires: $PasswordNeverExpiresUsers</li>
</ul>

<h2>User Details</h2>
"@

try {
    $Users |
        ConvertTo-Html -Head $HtmlHead -PreContent $HtmlPreContent |
        Out-File -FilePath $HtmlFile -Encoding UTF8

    Write-Log "HTML report saved to $HtmlFile." "SUCCESS"
}
catch {
    Write-Log "Failed to export HTML report. Error: $($_.Exception.Message)" "ERROR"
    exit 1
}

# -----------------------------
# Console Summary
# -----------------------------

Write-Host ""
Write-Host "=== AD User Report Summary ===" -ForegroundColor Cyan
Write-Host "Total users:                 $TotalUsers"
Write-Host "Enabled users:               $EnabledUsers"
Write-Host "Disabled users:              $DisabledUsers"
Write-Host "Stale users:                 $StaleUsers"
Write-Host "Locked-out users:            $LockedUsers"
Write-Host "Password never expires:      $PasswordNeverExpiresUsers"
Write-Host "CSV report:                  $CsvFile"
Write-Host "HTML report:                 $HtmlFile"
Write-Host "Log file:                    $LogFile"
Write-Host ""

$Users |
    Select-Object SamAccountName, DisplayName, Department, Enabled, StaleAccount, LastLogonDate |
    Format-Table -AutoSize

Write-Log "Completed Active Directory user report export." "SUCCESS"