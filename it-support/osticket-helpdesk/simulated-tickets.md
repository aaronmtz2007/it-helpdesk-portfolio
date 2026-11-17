# Simulated tickets (fictional data)

🇪🇸 [Versión en español](simulated-tickets.es.md)

The ten tickets were created and closed in osTicket, in Spanish. The users are the same ones from the Active Directory lab, with `@example.com` emails. English translations are in parentheses.

| Ticket | User | Help topic | Subject | Department | SLA | Closed by |
|---|---|---|---|---|---|---|
| #199835 | María García | Cuentas y contraseñas (Accounts and passwords) | No puedo iniciar sesión (I can't sign in) | Soporte TI (IT Support) | High (4 h) | Aaron |
| #799525 | Carlos Ramírez | Impresiones (Printing) | Impresora no imprime (Printer won't print) | Impresoras y periféricos (Printers and peripherals) | Normal (24 h) | Aaron |
| #764102 | Laura Díaz | Red e Internet (Network and Internet) | No tengo wifi (I have no Wi-Fi) | Redes (Networks) | High (4 h) | Laura |
| #636783 | Elena Vargas | Software | Instalar Zoom (Install Zoom) | Soporte TI | Normal (24 h) | Aaron |
| #450291 | Jorge Torres | Hardware | Laptop muy lenta (Very slow laptop) | Soporte TI | Normal (24 h) | Aaron |
| #278871 | Daniel Cruz | Solicitud de acceso (Access request) | Usuario nuevo en la empresa (New user in the company) | Soporte TI | Normal (24 h) | Aaron |
| #541839 | Ana López | Red e Internet | No abre carpeta compartida (Can't open shared folder) | Redes, transferred to Soporte TI | High (4 h) | Laura |
| #622925 | Pedro Sánchez | Red e Internet | VPN no conecta (VPN won't connect) | Redes | Critical (1 h), overdue | Laura |
| #656635 | Sofía Morales | Otros (Other) | Correo con spam (Spam email) | Soporte TI | Low (72 h) | Aaron |
| #931830 | Luis Hernández | Hardware | Mouse y teclado no responden (Mouse and keyboard don't respond) | Soporte TI | Normal (24 h) | Aaron |

Ticket #467647 ("osTicket Installed!") is created by osTicket when it is installed. It is not one of the ten.

## Cause and solution for each ticket

1. **#199835, locked account.** The account was locked after 3 failed attempts. I checked the user's identity, unlocked it with `Unlock-ADAccount` and reset the password with a forced change at next sign-in.
2. **#799525, printer.** Stuck print queue. I stopped the Spooler service, cleaned `C:\Windows\System32\spool\PRINTERS` and restarted the service.
3. **#764102, no internet.** The computer had a 169.254.x.x IP (no DHCP). `ipconfig /release`, `/renew` and `/flushdns`.
4. **#636783, Zoom.** Authorized request. I installed it with an administrator account and tested audio and camera.
5. **#450291, slow laptop.** Disk at 100 % because of startup programs. I disabled them, freed up space and updated the computer.
6. **#278871, new user.** Created the account in Active Directory (OU Direccion, group `GG_Direccion`), set up email and gave temporary credentials through a secure channel.
7. **#541839, shared folder.** It looked like a network problem but it was a permissions one: I transferred it to Soporte TI and added the user to the `GG_Compras` group.
8. **#622925, VPN.** The computer's clock was off. I synced it with `w32tm /resync`. This ticket was used to test an overdue critical SLA.
9. **#656635, spam.** I explained how to recognize phishing, reported the emails and changed the password as a precaution.
10. **#931830, mouse and keyboard.** Broken peripherals (they also failed on another computer). I replaced them and logged the change in the inventory.
