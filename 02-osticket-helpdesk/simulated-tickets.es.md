# Tickets simulados (datos ficticios)

🇺🇸 [English version](simulated-tickets.md)

Los diez tickets se crearon y se cerraron en osTicket. Los usuarios son los mismos del laboratorio de Active Directory, con correos `@example.com`.

| Ticket | Usuario | Tema de ayuda | Asunto | Departamento | SLA | Agente que lo cerró |
|---|---|---|---|---|---|---|
| #199835 | María García | Cuentas y contraseñas | No puedo iniciar sesión | Soporte TI | Alto | Aaron |
| #799525 | Carlos Ramírez | Impresiones | Impresora no imprime | Impresoras y periféricos | Normal | Aaron |
| #764102 | Laura Díaz | Red e Internet | No tengo wifi | Redes | Alto | Laura |
| #636783 | Elena Vargas | Software | Instalar Zoom | Soporte TI | Normal | Aaron |
| #450291 | Jorge Torres | Hardware | Laptop muy lenta | Soporte TI | Normal | Aaron |
| #278871 | Daniel Cruz | Solicitud de acceso | Usuario nuevo en la empresa | Soporte TI | Normal | Aaron |
| #541839 | Ana López | Red e Internet | No abre carpeta compartida | Redes, transferido a Soporte TI | Alto | Laura |
| #622925 | Pedro Sánchez | Red e Internet | VPN no conecta | Redes | Crítico (vencido) | Laura |
| #656635 | Sofía Morales | Otros | Correo con spam | Soporte TI | Bajo | Aaron |
| #931830 | Luis Hernández | Hardware | Mouse y teclado no responden | Soporte TI | Normal | Aaron |

El ticket #467647 ("osTicket Installed!") lo crea osTicket al instalarse, no es uno de los diez.

## Causa y solución de cada ticket

1. **#199835, cuenta bloqueada.** La cuenta se bloqueó por 3 intentos fallidos. Se verificó la identidad, se desbloqueó con `Unlock-ADAccount` y se restableció la contraseña con cambio obligatorio.
2. **#799525, impresora.** Cola de impresión atascada. Se detuvo el Spooler, se limpió `C:\Windows\System32\spool\PRINTERS` y se reinició el servicio.
3. **#764102, sin internet.** El equipo tenía una IP 169.254.x.x (sin DHCP). `ipconfig /release`, `/renew` y `/flushdns`.
4. **#636783, Zoom.** Solicitud autorizada. Se instaló con una cuenta de administrador y se probó audio y cámara.
5. **#450291, laptop lenta.** Disco al 100 % por programas de inicio. Se deshabilitaron, se liberó espacio y se actualizó el equipo.
6. **#278871, usuario nuevo.** Alta en Active Directory (OU Direccion, grupo `GG_Direccion`), correo y credenciales temporales por un canal seguro.
7. **#541839, carpeta compartida.** Parecía un problema de red, pero era de permisos: se transfirió a Soporte TI y se agregó a la usuaria al grupo `GG_Compras`.
8. **#622925, VPN.** Hora del equipo desfasada. Se sincronizó con `w32tm /resync`. Este ticket se usó para probar un SLA crítico vencido.
9. **#656635, spam.** Se explicó cómo reconocer phishing, se reportaron los correos y se cambió la contraseña por precaución.
10. **#931830, mouse y teclado.** Periféricos dañados (también fallaban en otro equipo). Se reemplazaron y se registró en el inventario.
