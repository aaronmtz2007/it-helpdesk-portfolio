<#
.SYNOPSIS
  Creates the lab's OUs, groups and users from users.csv (fictional data).
.DESCRIPTION
  The structure I build is:
    OU=Empresa
      - one OU per department, where that department's users go
      - OU=Grupos, with one global group GG_<Department> per department
  Each user ends up in their department's OU and as a member of their group.
  I wrote it so I can run it again without breaking anything: if an OU, a group
  or a user already exists, it skips it.
.EXAMPLE
  .\03-New-BulkUsers.ps1 -WhatIf      # simulates and shows what it would do, creates nothing
  .\03-New-BulkUsers.ps1              # creates everything for real; asks for the initial password
#>
#Requires -Modules ActiveDirectory
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$CsvPath = (Join-Path $PSScriptRoot "users.csv"),
    [SecureString]$InitialPassword
)

$ErrorActionPreference = "Stop"   # if something fails I'd rather it stops than keeps going half done
$domain  = Get-ADDomain
$dn      = $domain.DistinguishedName
$upnSuf  = $domain.DNSRoot
$rootOU  = "OU=Empresa,$dn"

# The password isn't written in the script or the CSV: I ask for it when I run it
if (-not $InitialPassword) {
    $InitialPassword = Read-Host "Contraseña inicial para los usuarios (cumple la política de dominio)" -AsSecureString
}

# Creates the OU only if it doesn't exist and returns its path (DistinguishedName)
function Ensure-OU($name, $path) {
    $target = "OU=$name,$path"
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$target'" -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($target, "Crear OU")) {
            New-ADOrganizationalUnit -Name $name -Path $path -ProtectedFromAccidentalDeletion $true
        }
        Write-Host "[OU] creada: $target" -ForegroundColor Green
    }
    return $target
}

if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$rootOU'" -ErrorAction SilentlyContinue)) {
    if ($PSCmdlet.ShouldProcess($rootOU, "Crear OU raíz")) {
        New-ADOrganizationalUnit -Name "Empresa" -Path $dn -ProtectedFromAccidentalDeletion $true
    }
}
$groupsOU = Ensure-OU "Grupos" $rootOU

# Go through the CSV: for each row I make sure its OU and group exist,
# and then I create the user
$created = 0; $skipped = 0
foreach ($row in Import-Csv -Path $CsvPath) {
    $deptOU = Ensure-OU $row.Department $rootOU
    $group  = "GG_$($row.Department)"

    if (-not (Get-ADGroup -Filter "Name -eq '$group'" -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($group, "Crear grupo")) {
            New-ADGroup -Name $group -GroupScope Global -GroupCategory Security -Path $groupsOU
        }
        Write-Host "[GRP] creado: $group" -ForegroundColor Green
    }

    if (Get-ADUser -Filter "SamAccountName -eq '$($row.Username)'" -ErrorAction SilentlyContinue) {
        Write-Host "[USR] ya existe, omitido: $($row.Username)" -ForegroundColor Yellow
        $skipped++
        continue
    }

    # ChangePasswordAtLogon: each user changes the initial password at their first sign-in
    if ($PSCmdlet.ShouldProcess($row.Username, "Crear usuario")) {
        New-ADUser -Name "$($row.FirstName) $($row.LastName)" `
            -GivenName $row.FirstName -Surname $row.LastName `
            -SamAccountName $row.Username `
            -UserPrincipalName "$($row.Username)@$upnSuf" `
            -Department $row.Department -Title $row.Title `
            -Path $deptOU -AccountPassword $InitialPassword `
            -ChangePasswordAtLogon $true -Enabled $true
        Add-ADGroupMember -Identity $group -Members $row.Username
    }
    Write-Host "[USR] creado: $($row.Username) -> $group" -ForegroundColor Green
    $created++
}
Write-Host "`nListo. Creados: $created · Omitidos: $skipped" -ForegroundColor Cyan
