<#
.SYNOPSIS
  Sets up DC01 and turns it into the domain controller of electro.local.
.DESCRIPTION
  I run it in two phases because Windows has to reboot between them:
    1) set a static IP and rename the computer to DC01 (reboots)
    2) install AD DS and DNS and promote the server to domain controller (reboots again)
  The file C:\setup-dc.state tells the script which phase it is in when I run it again.
.NOTES
  I run it as administrator inside the server VM.
  Before that I check the name of my internal network adapter with Get-NetAdapter.
#>
$LabAdapter  = "Ethernet 2"          # the adapter connected to the internal network 'labnet' (the other one is the NAT)
$IPAddress   = "192.168.50.10"
$Prefix      = 24
$NewName     = "DC01"
$DomainName  = "electro.local"
$NetBIOS     = "ELECTRO"
$StateFile   = "C:\setup-dc.state"

if (-not (Test-Path $StateFile)) {
    # Phase 1: static IP and computer name. The server's DNS points to itself (127.0.0.1)
    # because this same machine is going to be the domain's DNS.
    New-NetIPAddress -InterfaceAlias $LabAdapter -IPAddress $IPAddress -PrefixLength $Prefix
    Set-DnsClientServerAddress -InterfaceAlias $LabAdapter -ServerAddresses 127.0.0.1
    "fase1" | Out-File $StateFile
    Rename-Computer -NewName $NewName -Force -Restart
    return
}

if ((Get-Content $StateFile) -eq "fase1") {
    # Phase 2: install the roles and promote the server.
    # The DSRM (restore mode) password has to meet Windows complexity rules;
    # the first time I ran it I used a weak one and the promotion failed.
    Install-WindowsFeature AD-Domain-Services, DNS, GPMC -IncludeManagementTools
    "fase2" | Out-File $StateFile
    $dsrm = Read-Host "Contraseña DSRM (modo restauración)" -AsSecureString
    Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetBIOS `
        -InstallDns -SafeModeAdministratorPassword $dsrm -Force
    # When it finishes, the server reboots by itself.
}
else {
    Write-Host "Ya promovido. Verifica con: Get-ADDomain; dcdiag /q"
    Remove-Item $StateFile -ErrorAction SilentlyContinue
}
