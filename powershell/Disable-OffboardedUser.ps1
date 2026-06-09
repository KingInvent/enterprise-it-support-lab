<#
.SYNOPSIS
Disables and offboards an Active Directory user account for the BlancoTech lab.

.DESCRIPTION
This script performs a standard Active Directory offboarding workflow:
- Validates the user exists
- Disables the account
- Removes group memberships except Domain Users
- Clears the Manager attribute
- Updates the Description field with offboarding details
- Moves the account to the Disabled Users OU
- Logs all actions to C:\Logs\OffboardingLog.txt

.PARAMETER SamAccountName
SamAccountName of the user being offboarded.

.PARAMETER Reason
Reason for offboarding. Valid values: Resignation, Termination, Contract End, Other.

.PARAMETER TicketNumber
Optional ticket number or reference for documentation.

.EXAMPLE
.\Disable-OffboardedUser.ps1 -SamAccountName "cmendez" -Reason "Resignation" -TicketNumber "INC-1007"

.EXAMPLE
.\Disable-OffboardedUser.ps1 -SamAccountName "jlee" -Reason "Contract End"

.NOTES
Author: Darko Blancovich
Purpose: IT portfolio lab — BlancoTech Solutions AD automation
Requires: ActiveDirectory PowerShell module, Domain Admin or delegated rights
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$SamAccountName,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Resignation", "Termination", "Contract End", "Other")]
    [string]$Reason,

    [Parameter(Mandatory = $false)]
    [string]$TicketNumber = "N/A"
)

# -----------------------------
# Configuration
# -----------------------------

$DomainDN = "DC=blancotech,DC=local"
$DisabledUsersOU = "OU=Disabled Users,OU=BlancoTech,$DomainDN"
$LogDirectory = "C:\Logs"
$LogFile = "$LogDirectory\OffboardingLog.txt"
$OffboardingDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

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

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Entry = "$Timestamp [$Level] $Message"

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

Write-Log "Starting offboarding workflow for $SamAccountName. Reason: $Reason. Ticket: $TicketNumber" "INFO"

# -----------------------------
# Validate User
# -----------------------------

try {
    $User = Get-ADUser `
        -Identity $SamAccountName `
        -Properties MemberOf, DistinguishedName, DisplayName, Enabled, Manager, Department, Title `
        -ErrorAction Stop
}
catch {
    Write-Log "User not found: $SamAccountName" "ERROR"
    exit 1
}

$DisabledOUExists = Get-ADOrganizationalUnit -LDAPFilter "(distinguishedName=$DisabledUsersOU)" -ErrorAction SilentlyContinue

if (-not $DisabledOUExists) {
    Write-Log "Disabled Users OU does not exist: $DisabledUsersOU" "ERROR"
    exit 1
}

Write-Log "Validated user: $($User.DisplayName)" "SUCCESS"

# -----------------------------
# Disable Account
# -----------------------------

try {
    Disable-ADAccount -Identity $SamAccountName -ErrorAction Stop
    Write-Log "Disabled account: $SamAccountName" "SUCCESS"
}
catch {
    Write-Log "Failed to disable account $SamAccountName. Error: $($_.Exception.Message)" "ERROR"
    exit 1
}

# -----------------------------
# Remove Group Memberships
# -----------------------------

try {
    $Groups = Get-ADPrincipalGroupMembership -Identity $SamAccountName |
        Where-Object { $_.Name -ne "Domain Users" }

    if ($Groups.Count -eq 0) {
        Write-Log "No removable group memberships found for $SamAccountName." "INFO"
    }
    else {
        foreach ($Group in $Groups) {
            Remove-ADGroupMember `
                -Identity $Group.DistinguishedName `
                -Members $SamAccountName `
                -Confirm:$false `
                -ErrorAction Stop

            Write-Log "Removed $SamAccountName from group: $($Group.Name)" "SUCCESS"
        }
    }
}
catch {
    Write-Log "Failed while removing group memberships. Error: $($_.Exception.Message)" "ERROR"
}

# -----------------------------
# Clear Manager Attribute
# -----------------------------

try {
    Set-ADUser -Identity $SamAccountName -Clear Manager -ErrorAction Stop
    Write-Log "Cleared Manager attribute for $SamAccountName." "SUCCESS"
}
catch {
    Write-Log "Could not clear Manager attribute for $SamAccountName. Error: $($_.Exception.Message)" "WARNING"
}

# -----------------------------
# Update Description
# -----------------------------

$Description = "Offboarded on $OffboardingDate. Reason: $Reason. Ticket: $TicketNumber."

try {
    Set-ADUser -Identity $SamAccountName -Description $Description -ErrorAction Stop
    Write-Log "Updated Description field for $SamAccountName." "SUCCESS"
}
catch {
    Write-Log "Failed to update Description field. Error: $($_.Exception.Message)" "WARNING"
}

# -----------------------------
# Move to Disabled Users OU
# -----------------------------

try {
    $UpdatedUser = Get-ADUser -Identity $SamAccountName -Properties DistinguishedName -ErrorAction Stop

    Move-ADObject `
        -Identity $UpdatedUser.DistinguishedName `
        -TargetPath $DisabledUsersOU `
        -ErrorAction Stop

    Write-Log "Moved $SamAccountName to Disabled Users OU." "SUCCESS"
}
catch {
    Write-Log "Failed to move $SamAccountName to Disabled Users OU. Error: $($_.Exception.Message)" "ERROR"
    exit 1
}

# -----------------------------
# Final Validation
# -----------------------------

try {
    $FinalUser = Get-ADUser `
        -Identity $SamAccountName `
        -Properties Enabled, DistinguishedName, Description `
        -ErrorAction Stop

    $RemainingGroups = Get-ADPrincipalGroupMembership -Identity $SamAccountName |
        Select-Object -ExpandProperty Name |
        Sort-Object
}
catch {
    Write-Log "Final validation failed for $SamAccountName. Error: $($_.Exception.Message)" "WARNING"
}

# -----------------------------
# Summary
# -----------------------------

Write-Host ""
Write-Host "=== Offboarding Summary ===" -ForegroundColor Cyan
Write-Host "User:                  $($User.DisplayName)"
Write-Host "Username:              $SamAccountName"
Write-Host "Reason:                $Reason"
Write-Host "Ticket:                $TicketNumber"
Write-Host "Account disabled:      True"
Write-Host "Groups removed:        All except Domain Users"
Write-Host "Manager cleared:       True"
Write-Host "Moved to OU:           $DisabledUsersOU"
Write-Host "Description:           $Description"
Write-Host "Remaining groups:      $($RemainingGroups -join ', ')"
Write-Host "Log file:              $LogFile"
Write-Host ""

Write-Log "Completed offboarding workflow for $SamAccountName." "SUCCESS"