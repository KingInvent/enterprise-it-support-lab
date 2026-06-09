<#
.SYNOPSIS
Exports Active Directory group membership reports for BlancoTech Solutions.

.DESCRIPTION
Queries AD security groups and exports group membership details including:
- Group name
- Member name
- SamAccountName
- Object class
- Department
- Title
- Enabled status
- Distinguished Name

The script outputs both CSV and HTML reports and logs all actions.

.PARAMETER OutputPath
Folder where CSV and HTML reports will be saved. Default: C:\Reports

.PARAMETER GroupName
Optional specific group to report on. If omitted, all groups under the BlancoTech Groups OU are queried.

.EXAMPLE
.\Get-GroupMembershipReport.ps1

.EXAMPLE
.\Get-GroupMembershipReport.ps1 -GroupName "VPN-Users"

.EXAMPLE
.\Get-GroupMembershipReport.ps1 -OutputPath "C:\Reports"

.NOTES
Author: Darko Blancovich
Purpose: IT portfolio lab — BlancoTech Solutions AD group membership reporting
Requires: ActiveDirectory PowerShell module, Domain Admin or delegated rights
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "C:\Reports",

    [Parameter(Mandatory = $false)]
    [string]$GroupName = ""
)

# -----------------------------
# Configuration
# -----------------------------

$GroupsSearchBase = "OU=Groups,OU=BlancoTech,DC=blancotech,DC=local"
$LogDirectory = "C:\Logs"
$LogFile = "$LogDirectory\GroupMembershipReportLog.txt"

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$CsvFile = "$OutputPath\GroupMembershipReport_$Timestamp.csv"
$HtmlFile = "$OutputPath\GroupMembershipReport_$Timestamp.html"

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

Write-Log "Starting Active Directory group membership report export." "INFO"

# -----------------------------
# Get Groups
# -----------------------------

try {
    if ($GroupName -ne "") {
        $Groups = @(Get-ADGroup -Identity $GroupName -Properties Description -ErrorAction Stop)
        Write-Log "Reporting on specific group: $GroupName" "INFO"
    }
    else {
        $Groups = Get-ADGroup -Filter * -SearchBase $GroupsSearchBase -Properties Description -ErrorAction Stop |
            Sort-Object Name

        Write-Log "Reporting on all groups under $GroupsSearchBase." "INFO"
    }
}
catch {
    Write-Log "Failed to query groups. Error: $($_.Exception.Message)" "ERROR"
    exit 1
}

if (-not $Groups) {
    Write-Log "No groups found." "WARNING"
    exit 0
}

# -----------------------------
# Build Report
# -----------------------------

$Report = foreach ($Group in $Groups) {
    try {
        $Members = Get-ADGroupMember -Identity $Group.DistinguishedName -Recursive -ErrorAction Stop

        if (-not $Members) {
            [PSCustomObject]@{
                GroupName         = $Group.Name
                GroupDescription  = $Group.Description
                MemberName        = "No members"
                SamAccountName    = ""
                ObjectClass       = ""
                Department        = ""
                Title             = ""
                Enabled           = ""
                DistinguishedName = ""
            }
        }
        else {
            foreach ($Member in $Members) {
                $Department = ""
                $Title = ""
                $Enabled = ""

                if ($Member.objectClass -eq "user") {
                    try {
                        $UserDetails = Get-ADUser -Identity $Member.SamAccountName -Properties Department, Title, Enabled -ErrorAction Stop
                        $Department = $UserDetails.Department
                        $Title = $UserDetails.Title
                        $Enabled = $UserDetails.Enabled
                    }
                    catch {
                        $Department = "Lookup failed"
                        $Title = "Lookup failed"
                        $Enabled = "Lookup failed"
                    }
                }

                [PSCustomObject]@{
                    GroupName         = $Group.Name
                    GroupDescription  = $Group.Description
                    MemberName        = $Member.Name
                    SamAccountName    = $Member.SamAccountName
                    ObjectClass       = $Member.objectClass
                    Department        = $Department
                    Title             = $Title
                    Enabled           = $Enabled
                    DistinguishedName = $Member.DistinguishedName
                }
            }
        }
    }
    catch {
        Write-Log "Failed to query members for group $($Group.Name). Error: $($_.Exception.Message)" "WARNING"

        [PSCustomObject]@{
            GroupName         = $Group.Name
            GroupDescription  = $Group.Description
            MemberName        = "Error querying group"
            SamAccountName    = ""
            ObjectClass       = ""
            Department        = ""
            Title             = ""
            Enabled           = ""
            DistinguishedName = ""
        }
    }
}

# -----------------------------
# Summary Counts
# -----------------------------

$TotalGroups = $Groups.Count
$TotalRows = $Report.Count
$UniqueUsers = ($Report | Where-Object { $_.ObjectClass -eq "user" -and $_.SamAccountName -ne "" } | Select-Object -ExpandProperty SamAccountName -Unique).Count
$DisabledMembers = ($Report | Where-Object { $_.Enabled -eq $false }).Count
$EmptyGroups = ($Report | Where-Object { $_.MemberName -eq "No members" }).Count

# -----------------------------
# Export CSV
# -----------------------------

try {
    $Report | Export-Csv -Path $CsvFile -NoTypeInformation -Encoding UTF8
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
<h1>BlancoTech Solutions — AD Group Membership Report</h1>
<p><strong>Generated:</strong> $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
<p><strong>Groups Search Base:</strong> $GroupsSearchBase</p>
<p><strong>Specific Group:</strong> $(if ($GroupName -ne "") { $GroupName } else { "All BlancoTech groups" })</p>

<h2>Summary</h2>
<ul>
    <li>Total groups reviewed: $TotalGroups</li>
    <li>Total report rows: $TotalRows</li>
    <li>Unique user members: $UniqueUsers</li>
    <li>Disabled user members: $DisabledMembers</li>
    <li>Empty groups: $EmptyGroups</li>
</ul>

<h2>Group Membership Details</h2>
"@

try {
    $Report |
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
Write-Host "=== Group Membership Report Summary ===" -ForegroundColor Cyan
Write-Host "Groups reviewed:        $TotalGroups"
Write-Host "Report rows:            $TotalRows"
Write-Host "Unique user members:    $UniqueUsers"
Write-Host "Disabled user members:  $DisabledMembers"
Write-Host "Empty groups:           $EmptyGroups"
Write-Host "CSV report:             $CsvFile"
Write-Host "HTML report:            $HtmlFile"
Write-Host "Log file:               $LogFile"
Write-Host ""

$Report |
    Select-Object GroupName, MemberName, SamAccountName, ObjectClass, Department, Enabled |
    Format-Table -AutoSize

Write-Log "Completed Active Directory group membership report export." "SUCCESS"