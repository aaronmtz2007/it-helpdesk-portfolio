# Active Directory Home Lab (Windows Server 2022)

🇪🇸 [Leer en español](README.es.md) · Guide: [English](GUIDE.md) · [Español](GUIDE.es.md)

A small domain I built in VirtualBox to practice what a help desk tech does every day: create users, reset passwords, unlock accounts, apply group policies and share folders with permissions by group. Everything in here is fictional.

**Status:** 🟡 almost done (video pending) · **Time spent:** about 6 h · **Date:** November 2026

## Setup

| Part | Detail |
|---|---|
| Hypervisor | VirtualBox 7.2 on Windows 11 |
| Server | Windows Server 2022 Standard Evaluation, `DC01`, 192.168.50.10 (AD DS, DNS, DHCP, SMB) |
| Client | Windows 11 Enterprise Evaluation, `PC01` (DHCP) |
| Domain | `electro.local` |
| Network | internal network `labnet` + a NAT adapter on the server for internet |

```
        Internet
           |
        [NAT]
           |
  DC01 ----+---- internal network "labnet" 192.168.50.0/24 ---- PC01
 AD DS · DNS · DHCP · SMB                                      (domain client)
```

## What I did

- [x] Installed Server 2022 and promoted it to domain controller
- [x] DNS and DHCP (scope 192.168.50.100-200)
- [x] Installed the Windows 11 client and joined it to the domain
- [x] OUs, security groups and 10 users, created in bulk from a CSV with PowerShell
- [x] Reset a password and unlocked a locked account
- [x] Domain password policy (10 characters, complexity, 90 days, lockout after 3 attempts)
- [x] GPO that blocks Control Panel for the Operaciones OU
- [x] GPO that maps `\\DC01\Compras` as drive S: for the Compras OU
- [x] Shared folder where only `GG_Compras` can get in

## Scripts

| Script | What it does |
|---|---|
| [`01-Setup-DC.ps1`](scripts/01-Setup-DC.ps1) | static IP, AD DS role, promotion to DC |
| [`02-Setup-DHCP.ps1`](scripts/02-Setup-DHCP.ps1) | DHCP role and scope |
| [`03-New-BulkUsers.ps1`](scripts/03-New-BulkUsers.ps1) | OUs, groups and users from [`users.csv`](scripts/users.csv). Supports `-WhatIf` to simulate first |

Step by step with all the commands: [GUIDE.md](GUIDE.md) (English) · [GUIDE.es.md](GUIDE.es.md) (Español).

## Evidence

Screenshots are in [`evidence/`](evidence/). Video (3-5 min): _link pending_

| Step | Screenshot |
|---|---|
| VirtualBox network setup (NAT and `labnet` adapters) | `00a-virtualbox-adapter1-nat.png`, `00b-virtualbox-adapter2-labnet.png` |
| Server Manager on the new server | `00c-server-manager.png` |
| Domain created | `01-get-addomain.png` |
| DHCP scope | `02-dhcp.png` |
| Windows 11 installer blocking on requirements | `03b-win11-requirements.png` |
| PC01 joined to the domain | `03-join-domain.webp` |
| OUs, groups and users | `04-ous-users.png` |
| Account locked, then unlocked and password reset | `05a-lockout.png`, `05-unlock.png` |
| Password policy | `06-password-policy.png` |
| Control Panel GPO working (user `mgarcia`) | `07-gpo-control-panel-blocked.webp`, `07a-gpo-control-panel-link.png` |
| Shared folder permissions | `08-share.png` |
| Access allowed (`cramirez`) and denied (`mgarcia`) | `09-share-allowed.webp`, `10-share-denied.webp` |
| Drive map GPO | `11-gpo-map-drive.png`, `11a-mapped-drive.webp` |

## Problems I ran into and how I fixed them

1. **Virtualization was off.** VT-x was disabled in the BIOS. I turned on Intel Virtualization Technology.
2. **PC01 booted to a black screen.** The log showed the VM's EFI firmware hanging at startup. I switched the VM to legacy BIOS and set TPM to none.
3. **Windows 11 said the PC doesn't meet requirements.** The VM has no TPM 2.0 or Secure Boot. I added the `LabConfig` bypass keys from Shift+F10 during setup.
4. **Promoting the DC failed.** The DSRM password didn't meet complexity rules. I ran `Install-ADDSForest` again with a stronger one.
5. **The DNS returned extra IPs for the domain.** DC01 has two network cards, so it registered the NAT addresses in DNS too. I turned off registration on the NAT adapter and deleted those A/AAAA records.
6. **`Add-Computer` gave "Access is denied".** PowerShell wasn't elevated. I reopened it as administrator.
7. **PC01's evaluation license showed "Notification mode".** The VM clock was wrong during install. It doesn't block the lab, but the VM shuts down by itself from time to time, so I just turn it back on.
8. **I couldn't log in to PC01 with a domain account.** The `\` and `#` keys are in different places depending on the keyboard layout (ENG vs ESP). Logging in as `user@electro.local` and checking the layout fixed it.
9. **My PowerShell script showed weird characters (`ContraseÃ±a`).** Notepad saved it as UTF-8 without BOM and PowerShell 5.1 read it as ANSI. I rewrote it with `Set-Content -Encoding UTF8`.
10. **`\\DC01\Compras` failed with error 0x80070043 / 64.** The name resolved, but the internal network link between the VMs had dropped (ping said "Destination host unreachable" from PC01's own IP). Restarting the network adapter on PC01 brought it back. After that the correct "You do not have permission" message showed up for the user outside the group.

## What I learned

- Most "domain" problems are really DNS or network problems. `ping`, `nslookup` and `ipconfig /all` come first.
- A password reset and an unlock are two different things, and I need to check which one the user needs.
- Permissions work better through groups (`GG_*`) than per user, and NTFS and share permissions both count.
- Test a GPO with a user that should be affected and one that shouldn't, otherwise you don't really know it works.
- Keep notes while you do things. Writing the problems down as they happened made this README way easier.

## How I used AI

I used an AI assistant to save time on some tasks, mainly to check PowerShell command syntax and to find the right cmdlet. I built the lab, ran the commands myself, fixed the errors and took the screenshots.
