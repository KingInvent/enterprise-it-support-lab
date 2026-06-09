<#
.SYNOPSIS
Creates a new Active Directory user account for a BlancoTech new hire.

.DESCRIPTION
Automates the new hire onboarding process by creating an AD user account,
placing the user in the correct department OU, assigning group memberships,
optionally assigning VPN access, optionally assigning a manager, and logging
all actions to a log file.

.PARAMETER FirstName
First name of the new hire.

.PARAMETER LastName
Last name of the new hire.

.PARAMETER Department
Department the user belongs to. Valid values: HR, Finance, Sales, Operations, IT.

.PARAMETER JobTitle
Job title of the new hire.

.PARAMETER Manager
Optional SamAccountName of the user's manager.

.PARAMETER SamAccountName
Optional custom username. If omitted, the script creates one using first initial + last name.

.PARAMETER EnableVPN
Optional switch to add the user to VPN-Users.

.EXAMPLE
.\Create-NewHireUser.ps1 -FirstName "Carlos" -LastName "Mendez" -Department "Sales" -JobTitle "Sales Representative" -Manager "mgonzalez" -EnableVPN

.EXAMPLE
.\Create-NewHireUser.ps1 -FirstName "Ana" -LastName "Lopez" -Department "HR" -JobTitle "HR Coordinator"

.NOTES
Author: Darko Blancovich
Purpose: IT portfolio lab — BlancoTech Solutions AD automation
Requires: ActiveDirectory PowerShell module, Domain Admin or delegated rights
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$FirstName,

    [Parameter(Mandatory = $true)]
    [string]$LastName,

    [Parameter(Mandatory = $true)]
    [ValidateSet("HR", "Finance", "Sales", "Operations", "IT")]
    [string]$Department,

    [Parameter(Mandatory = $true)]
    [string]$JobTitle,

    [Parameter(Mandatory = $false)]
    [string]$Manager = "",

    [Parameter(Mandatory = $false)]
    [string]$SamAccountName,

    [Parameter(Mandatory = $false)]
    [switch]$EnableVPN
)

# -----------------------------
# Configuration
# -----------------------------

$DomainName = "blancotech.local"
$DomainDN = "DC=blancotech,DC=local"
$BaseOU = "OU=Users,OU=BlancoTech,$DomainDN"
$LogDirectory = "C:\Logs"
$LogFile = "$LogDirectory\NewHireLog.txt"

$DepartmentMap = @{
    "HR" = @{
        OU = "OU=HR,$BaseOU"
        Group = "HR-Users"
    }
    "Finance" = @{
        OU = "OU=Finance,$BaseOU"
        Group = "Finance-Users"
    }
    "Sales" = @{
        OU = "OU=Sales,$BaseOU"
        Group = "Sales-Users"
    }
    "Operations" = @{
        OU = "OU=Operations,$BaseOU"
        Group = "Operations-Users"
    }
    "IT" = @{
        OU = "OU=IT,$BaseOU"
        Group = "IT-Users"
    }
}

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

if (-not $SamAccountName) {
    $SamAccountName = ("{0}{1}" -f $FirstName.Substring(0,1), $LastName).ToLower()
}

$DisplayName = "$FirstName $LastName"
$UserPrincipalName = "$SamAccountName@$DomainName"
$TargetOU = $DepartmentMap[$Department].OU
$DepartmentGroup = $DepartmentMap[$Department].Group

$RequiredGroups = @("All-Employees", $DepartmentGroup)

if ($EnableVPN) {
    $RequiredGroups += "VPN-Users"
}

Write-Log "Starting new hire onboarding for $DisplayName." "INFO"

# -----------------------------
# Validation
# -----------------------------

$ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -ErrorAction SilentlyContinue

if ($ExistingUser) {
    Write-Log "User $SamAccountName already exists. Exiting." "ERROR"
    exit 1
}

$OUExists = Get-ADOrganizationalUnit -LDAPFilter "(distinguishedName=$TargetOU)" -ErrorAction SilentlyContinue

if (-not $OUExists) {
    Write-Log "Target OU does not exist: $TargetOU" "ERROR"
    exit 1
}

foreach ($Group in $RequiredGroups) {
    $GroupExists = Get-ADGroup -Identity $Group -ErrorAction SilentlyContinue

    if (-not $GroupExists) {
        Write-Log "Required group does not exist: $Group" "ERROR"
        exit 1
    }
}

$ManagerDN = $null

if ($Manager -ne "") {
    try {
        $ManagerDN = (Get-ADUser -Identity $Manager -ErrorAction Stop).DistinguishedName
        Write-Log "Manager validated: $Manager" "INFO"
    }
    catch {
        Write-Log "Manager account not found: $Manager" "ERROR"
        exit 1
    }
}

# -----------------------------
# Password Prompt
# -----------------------------

$TemporaryPassword = Read-Host "Enter temporary password for $SamAccountName" -AsSecureString

# -----------------------------
# Create User
# -----------------------------

try {
    $UserParams = @{
        Name                  = $DisplayName
        GivenName             = $FirstName
        Surname               = $LastName
        SamAccountName        = $SamAccountName
        UserPrincipalName     = $UserPrincipalName
        DisplayName           = $DisplayName
        Department            = $Department
        Title                 = $JobTitle
        Path                  = $TargetOU
        AccountPassword       = $TemporaryPassword
        Enabled               = $true
        ChangePasswordAtLogon = $true
        ErrorAction           = "Stop"
    }

    if ($ManagerDN) {
        $UserParams["Manager"] = $ManagerDN
    }

    New-ADUser @UserParams

    Write-Log "Created AD user $SamAccountName in $TargetOU." "SUCCESS"
}
catch {
    Write-Log "Failed to create AD user $SamAccountName. Error: $($_.Exception.Message)" "ERROR"
    exit 1
}

# -----------------------------
# Assign Groups
# -----------------------------

foreach ($Group in $RequiredGroups) {
    try {
        Add-ADGroupMember -Identity $Group -Members $SamAccountName -ErrorAction Stop
        Write-Log "Added $SamAccountName to $Group." "SUCCESS"
    }
    catch {
        Write-Log "Failed to add $SamAccountName to $Group. Error: $($_.Exception.Message)" "ERROR"
    }
}

# -----------------------------
# Summary
# -----------------------------

Write-Host ""
Write-Host "=== New Hire Account Summary ===" -ForegroundColor Cyan
Write-Host "Name:                         $DisplayName"
Write-Host "Username:                     $SamAccountName"
Write-Host "UPN:                          $UserPrincipalName"
Write-Host "Department:                   $Department"
Write-Host "Job Title:                    $JobTitle"
Write-Host "OU:                           $TargetOU"
Write-Host "Groups:                       $($RequiredGroups -join ', ')"
Write-Host "Manager:                      $(if ($Manager -ne '') { $Manager } else { 'Not assigned' })"
Write-Host "Password change at next logon: True"
Write-Host "Log file:                     $LogFile"
Write-Host ""

Write-Log "Completed new hire onboarding for $SamAccountName." "SUCCESS"