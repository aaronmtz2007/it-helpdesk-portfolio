# Printer won't print: stuck queue

🇪🇸 [Versión en español](02-printer-stuck-queue.es.md)

**Symptom:** the document stays in the queue as "Printing" and never comes out.

## Solution
In PowerShell as administrator, on the user's computer:
```powershell
Stop-Service Spooler
Remove-Item C:\Windows\System32\spool\PRINTERS\* -Force
Start-Service Spooler
```
Print a test page. If it still fails: check the printer's cable or network, that it is the default printer, and the driver.
