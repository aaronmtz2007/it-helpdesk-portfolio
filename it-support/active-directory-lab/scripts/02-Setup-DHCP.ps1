<#
.SYNOPSIS
  Installs DHCP on DC01 and creates the scope so PC01 gets an automatic IP.
.DESCRIPTION
  The scope hands out 192.168.50.100 to 192.168.50.200. It also gives clients the DNS
  server (DC01), the domain and the gateway, so PC01 finds the domain without any
  manual configuration.
.NOTES
  I run it as administrator on DC01, once it is already a domain controller.
#>
Install-WindowsFeature DHCP -IncludeManagementTools

# In a domain, the DHCP server has to be authorized in Active Directory
# or it won't hand out addresses.
Add-DhcpServerInDC -DnsName "dc01.electro.local" -IPAddress 192.168.50.10

# Create the local DHCP groups so Server Manager stops warning about
# "pending configuration"
netsh dhcp add securitygroups | Out-Null
Restart-Service DHCPServer

# The scope and its options: 003 = gateway, 006 = DNS, 015 = domain
Add-DhcpServerv4Scope -Name "LAN-Lab" -StartRange 192.168.50.100 -EndRange 192.168.50.200 `
    -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerv4OptionValue -ScopeId 192.168.50.0 `
    -DnsServer 192.168.50.10 -DnsDomain "electro.local" -Router 192.168.50.10

# Mark the post-install configuration as finished
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2 -ErrorAction SilentlyContinue

# Show the scope at the end to check that it is active
Get-DhcpServerv4Scope
