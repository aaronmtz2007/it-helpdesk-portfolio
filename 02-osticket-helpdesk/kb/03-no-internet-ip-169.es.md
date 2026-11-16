# Sin internet: IP 169.254.x.x

🇺🇸 [English version](03-no-internet-ip-169.md)

**Síntoma:** conectado a la red pero sin navegación.
**Causa:** el equipo no recibió IP del DHCP (APIPA).

## Diagnóstico
```cmd
ipconfig /all
ping 127.0.0.1
ping <gateway>
nslookup google.com
```
## Solución
```cmd
ipconfig /release
ipconfig /renew
ipconfig /flushdns
```
Si no obtiene IP: revisar cable/Wi-Fi, reiniciar el adaptador, comprobar que el servidor DHCP esté activo. Escalar a Redes si afecta a varios usuarios.
