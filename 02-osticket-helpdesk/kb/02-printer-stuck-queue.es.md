# Impresora no imprime: cola atascada

🇺🇸 [English version](02-printer-stuck-queue.md)

**Síntoma:** el documento queda en cola "Imprimiendo" y no sale.

## Solución
En PowerShell como administrador, en el equipo del usuario:
```powershell
Stop-Service Spooler
Remove-Item C:\Windows\System32\spool\PRINTERS\* -Force
Start-Service Spooler
```
Imprimir página de prueba. Si sigue fallando: revisar cable/red de la impresora, que sea la impresora predeterminada y el controlador.
