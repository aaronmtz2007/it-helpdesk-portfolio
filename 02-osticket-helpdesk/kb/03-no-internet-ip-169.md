# No internet: 169.254.x.x IP

🇪🇸 [Versión en español](03-no-internet-ip-169.es.md)

**Symptom:** connected to the network but can't browse.
**Cause:** the computer didn't get an IP from DHCP (APIPA).

## Diagnosis
```cmd
ipconfig /all
ping 127.0.0.1
ping <gateway>
nslookup google.com
```

## Solution
```cmd
ipconfig /release
ipconfig /renew
ipconfig /flushdns
```
If it still doesn't get an IP: check the cable or Wi-Fi, restart the adapter and make sure the DHCP server is running. Escalate to Networks if it affects several users.
