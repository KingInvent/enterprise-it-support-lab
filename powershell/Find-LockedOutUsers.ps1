<#
.SYNOPSIS
Finds and optionally unlocks locked-out Active Directory user accounts for BlancoTech Solutions.

.DESCRIPTION
Queries Active Directory for locked-out user accounts and displays account details including:
- Username
- Display name
- Department
- Title
- Enabled status
- Bad logon count
- Bad password time
- Lockout time

The script exports CSV and HTML reports, logs all actions, and optionally unlocks locked-out
accounts when the -Unlock switch is used.

.PARAMETER OutputPath
Folder where CSV and HTML reports will be saved. Default: C:\Reports

.PARAMETER Unlock
Optional switch. If used, the script unlocks all currently locked-out user accounts found.

.EXAMPLE
.\Find-LockedOutUsers.ps1

.EXAMPLE
.\Find-LockedOutUsers.ps1 -OutputPath "C:\Reports"

.EXAMPLE
.\Find-LockedOutUsers.ps1 -Unlock

.EXAMPLE
.\Find-LockedOutUsers.ps1 -OutputPath "C:\Reports" -Unlock

.NOTES
Author: Darko Blancovich
Purpose: IT portfolio lab — BlancoTech Solutions AD account support automation
Requires: ActiveDirectory PowerShell module, Domain Admin or delegated rights
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "C:\Reports",

    [Parameter(Mandatory = $false)]
    [switch]$Unlock
)

# -----------------------------
# Configuration
# -----------------------------

$LogDirectory = "C:\Logs"
$LogFile = "$LogDirectory\LockedOutUsersLog.txt"

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$CsvFile = "$OutputPath\LockedOutUsers_$Timestamp.csv"
$HtmlFile = "$OutputPath\LockedOutUsers_$Timestamp.html"

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

Write-Log "Starting locked-out user account search." "INFO"

# -----------------------------
# Query Locked-Out Accounts
# -----------------------------

try {
    $LockedUsers = Search-ADAccount -LockedOut -UsersOnly |
        Get-ADUser -Properties DisplayName, Department, Title, Enabled, LockedOut, BadLogonCount, BadPasswordTime, LockoutTime, DistinguishedName |
        Select-Object `
            SamAccountName,
            DisplayName,
            Department,
            Title,
            Enabled,
            LockedOut,
            BadLogonCount,
            @{Name="BadPasswordTime"; Expression={
                if ($_.BadPasswordTime -and $_.BadPasswordTime -gt 0) {
                    [datetime]::FromFileTime($_.BadPasswordTime).ToString("yyyy-MM-dd HH:mm:ss")
                }
                else {
                    "N/A"
                }
            }},
            @{Name="LockoutTime"; Expression={
                if ($_.LockoutTime -and $_.LockoutTime -gt 0) {
                    [datetime]::FromFileTime($_.LockoutTime).ToString("yyyy-MM-dd HH:mm:ss")
                }
                else {
                    "N/A"
                }
            }},
            DistinguishedName
}
catch {
    Write-Log "Failed to query locked-out accounts. Error: $($_.Exception.Message)" "ERROR"
    exit 1
}

$LockedCount = if ($LockedUsers) { $LockedUsers.Count } else { 0 }

# -----------------------------
# Display Results
# -----------------------------

Write-Host ""
Write-Host "=== Locked-Out User Report ===" -ForegroundColor Cyan
Write-Host "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "Locked-out accounts found: $LockedCount"
Write-Host ""

if ($LockedCount -eq 0) {
    Write-Log "No locked-out accounts found." "SUCCESS"
    Write-Host "No locked-out accounts found." -ForegroundColor Green
}
else {
    Write-Log "Found $LockedCount locked-out account(s)." "WARNING"

    $LockedUsers |
        Format-Table SamAccountName, DisplayName, Department, Title, BadLogonCount, BadPasswordTime, LockoutTime -AutoSize
}

# -----------------------------
# Export CSV
# -----------------------------

try {
    if ($LockedCount -eq 0) {
        @(
            [PSCustomObject]@{
                SamAccountName  = "No locked-out accounts found"
                DisplayName     = ""
                Department      = ""
                Title           = ""
                Enabled         = ""
                LockedOut       = ""
                BadLogonCount   = ""
                BadPasswordTime = ""
                LockoutTime     = ""
                DistinguishedName = ""
            }
        ) | Export-Csv -Path $CsvFile -NoTypeInformation -Encoding UTF8
    }
    else {
        $LockedUsers | Export-Csv -Path $CsvFile -NoTypeInformation -Encoding UTF8
    }

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
<h1>BlancoTech Solutions — Locked-Out User Report</h1>
<p><strong>Generated:</strong> $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
<p><strong>Total locked-out accounts:</strong> $LockedCount</p>

<h2>Locked Account Details</h2>
"@

try {
    if ($LockedCount -eq 0) {
        $HtmlData = @(
            [PSCustomObject]@{
                Result = "No locked-out accounts found"
            }
        )
    }
    else {
        $HtmlData = $LockedUsers
    }

    $HtmlData |
        ConvertTo-Html -Head $HtmlHead -PreContent $HtmlPreContent |
        Out-File -FilePath $HtmlFile -Encoding UTF8

    Write-Log "HTML report saved to $HtmlFile." "SUCCESS"
}
catch {
    Write-Log "Failed to export HTML report. Error: $($_.Exception.Message)" "ERROR"
}

# -----------------------------
# Optional Unlock
# -----------------------------

if ($Unlock -and $LockedCount -gt 0) {
    Write-Log "Unlock switch detected. Starting account unlock process." "INFO"

    foreach ($User in $LockedUsers) {
        try {
            Unlock-ADAccount -Identity $User.SamAccountName -ErrorAction Stop
            Write-Log "Unlocked account: $($User.SamAccountName)" "SUCCESS"
        }
        catch {
            Write-Log "Failed to unlock account $($User.SamAccountName). Error: $($_.Exception.Message)" "ERROR"
        }
    }

    Write-Host ""
    Write-Host "=== Unlock Summary ===" -ForegroundColor Cyan
    Write-Host "Unlock attempted for: $LockedCount account(s)"
}
elseif ($Unlock -and $LockedCount -eq 0) {
    Write-Log "Unlock switch was used, but no locked-out accounts were found." "INFO"
}
else {
    Write-Host ""
    Write-Host "Report-only mode. To unlock locked-out accounts, run:"
    Write-Host ".\Find-LockedOutUsers.ps1 -Unlock"
}

# -----------------------------
# Final Summary
# -----------------------------

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Locked-out accounts:  $LockedCount"
Write-Host "CSV report:           $CsvFile"
Write-Host "HTML report:          $HtmlFile"
Write-Host "Log file:             $LogFile"
Write-Host ""

Write-Log "Locked-out user search completed. Total locked: $LockedCount" "SUCCESS"
