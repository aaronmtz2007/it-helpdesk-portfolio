# Laboratorio de Active Directory (Windows Server 2022)

🇺🇸 [Read in English](README.md) · Guía: [English](GUIDE.md) · [Español](GUIDE.es.md)

Un dominio pequeño que armé en VirtualBox para practicar lo que se hace todos los días en un Help Desk: crear usuarios, resetear contraseñas, desbloquear cuentas, aplicar políticas de grupo y compartir carpetas con permisos por grupo. Todos los datos son ficticios.

**Estado:** 🟡 casi listo (falta el video) · **Tiempo invertido:** unas 6 h · **Fecha:** noviembre 2026

## Entorno

| Parte | Detalle |
|---|---|
| Hipervisor | VirtualBox 7.2 en Windows 11 |
| Servidor | Windows Server 2022 Standard Evaluation, `DC01`, 192.168.50.10 (AD DS, DNS, DHCP, SMB) |
| Cliente | Windows 11 Enterprise Evaluation, `PC01` (DHCP) |
| Dominio | `electro.local` |
| Red | red interna `labnet` + un adaptador NAT en el servidor para tener internet |

```
        Internet
           |
        [NAT]
           |
  DC01 ----+---- red interna "labnet" 192.168.50.0/24 ---- PC01
 AD DS · DNS · DHCP · SMB                               (cliente de dominio)
```

## Qué hice

- [x] Instalé Server 2022 y lo promoví a controlador de dominio
- [x] DNS y DHCP (ámbito 192.168.50.100-200)
- [x] Instalé el cliente Windows 11 y lo uní al dominio
- [x] OUs, grupos de seguridad y 10 usuarios, creados en lote desde un CSV con PowerShell
- [x] Reseteé una contraseña y desbloqueé una cuenta bloqueada
- [x] Política de contraseñas del dominio (10 caracteres, complejidad, 90 días, bloqueo a los 3 intentos)
- [x] GPO que bloquea el Panel de control para la OU Operaciones
- [x] GPO que mapea `\\DC01\Compras` como unidad S: para la OU Compras
- [x] Carpeta compartida donde solo entra `GG_Compras`

## Scripts

| Script | Para qué |
|---|---|
| [`01-Setup-DC.ps1`](scripts/01-Setup-DC.ps1) | IP fija, rol AD DS, promoción a DC |
| [`02-Setup-DHCP.ps1`](scripts/02-Setup-DHCP.ps1) | Rol DHCP y ámbito |
| [`03-New-BulkUsers.ps1`](scripts/03-New-BulkUsers.ps1) | OUs, grupos y usuarios desde [`users.csv`](scripts/users.csv). Con `-WhatIf` se simula primero |

Paso a paso con todos los comandos: [GUIDE.es.md](GUIDE.es.md) (Español) · [GUIDE.md](GUIDE.md) (English).

## Evidencia

Las capturas están en [`evidence/`](evidence/). Video (3-5 min): _enlace pendiente_

| Paso | Captura |
|---|---|
| Red en VirtualBox (adaptadores NAT y `labnet`) | `00a-virtualbox-adapter1-nat.png`, `00b-virtualbox-adapter2-labnet.png` |
| Server Manager del servidor nuevo | `00c-server-manager.png` |
| Dominio creado | `01-get-addomain.png` |
| Ámbito DHCP | `02-dhcp.png` |
| El instalador de Windows 11 bloqueando por requisitos | `03b-win11-requirements.png` |
| PC01 unida al dominio | `03-join-domain.webp` |
| OUs, grupos y usuarios | `04-ous-users.png` |
| Cuenta bloqueada, luego desbloqueada y con contraseña reseteada | `05a-lockout.png`, `05-unlock.png` |
| Política de contraseñas | `06-password-policy.png` |
| GPO del Panel de control funcionando (usuario `mgarcia`) | `07-gpo-control-panel-blocked.webp`, `07a-gpo-control-panel-link.png` |
| Permisos de la carpeta compartida | `08-share.png` |
| Acceso permitido (`cramirez`) y denegado (`mgarcia`) | `09-share-allowed.webp`, `10-share-denied.webp` |
| GPO de unidad de red | `11-gpo-map-drive.png`, `11a-mapped-drive.webp` |

## Problemas que tuve y cómo los resolví

1. **La virtualización estaba apagada.** VT-x estaba desactivado en la BIOS. Activé Intel Virtualization Technology.
2. **PC01 arrancaba con pantalla negra.** El log mostraba que el firmware EFI de la VM se colgaba al iniciar. Cambié la VM a BIOS clásico y puse el TPM en ninguno.
3. **Windows 11 decía que el equipo no cumple los requisitos.** La VM no tiene TPM 2.0 ni Secure Boot. Agregué las claves `LabConfig` de bypass desde Shift+F10 durante la instalación.
4. **Falló la promoción a DC.** La contraseña DSRM no cumplía la complejidad. Volví a ejecutar `Install-ADDSForest` con una más fuerte.
5. **El DNS devolvía IPs de más para el dominio.** DC01 tiene dos tarjetas, así que registró también las direcciones del NAT en el DNS. Desactivé el registro en el adaptador NAT y borré esos registros A/AAAA.
6. **`Add-Computer` daba "Access is denied".** PowerShell no estaba elevado. Lo abrí de nuevo como administrador.
7. **La licencia de evaluación de PC01 mostraba "Notification mode".** El reloj de la VM estaba mal al instalar. No bloquea el lab, pero la VM se apaga sola de vez en cuando, así que solo la vuelvo a encender.
8. **No podía entrar a PC01 con una cuenta de dominio.** Las teclas `\` y `#` están en lugares distintos según el idioma del teclado (ENG vs ESP). Entrar como `usuario@electro.local` y revisar el idioma lo arregló.
9. **Mi script de PowerShell mostraba caracteres raros (`ContraseÃ±a`).** El Bloc de notas lo guardó en UTF-8 sin BOM y PowerShell 5.1 lo leyó como ANSI. Lo reescribí con `Set-Content -Encoding UTF8`.
10. **`\\DC01\Compras` fallaba con el error 0x80070043 / 64.** El nombre se resolvía, pero el enlace de la red interna entre las VMs se había caído (el ping decía "Destination host unreachable" desde la IP de PC01). Reiniciar el adaptador de red de PC01 lo regresó. Después ya salió el mensaje correcto de "no tienes permiso" para el usuario fuera del grupo.

## Qué aprendí

- Casi todos los problemas de "dominio" son en realidad de DNS o de red. Primero va `ping`, `nslookup` e `ipconfig /all`.
- Resetear contraseña y desbloquear son cosas distintas, y hay que revisar cuál necesita el usuario.
- Los permisos funcionan mejor por grupos (`GG_*`) que por usuario, y cuentan tanto los permisos NTFS como los del recurso compartido.
- Una GPO se prueba con un usuario que debería verse afectado y otro que no, si no, no sabes si de verdad funciona.
- Hay que ir anotando mientras haces las cosas. Escribir los problemas en el momento hizo este README mucho más fácil.

## Cómo usé la IA

Usé un asistente de IA para ahorrar tiempo en algunas tareas, sobre todo para consultar la sintaxis de comandos de PowerShell y encontrar el cmdlet correcto. El lab lo armé yo, ejecuté los comandos, arreglé los errores y tomé las capturas.
