# Locked Active Directory account

🇪🇸 [Versión en español](01-unlock-ad-account.es.md)

**Symptom:** "The account is locked" when signing in.
**Usual cause:** several attempts with a wrong password (the lockout threshold of the policy was reached).

## Solution (agent)
1. Verify the user's identity.
2. On the domain controller:
   ```powershell
   Search-ADAccount -LockedOut
   Unlock-ADAccount -Identity <user>
   ```
3. If the user forgot the password:
   ```powershell
   Set-ADAccountPassword -Identity <user> -Reset -NewPassword (Read-Host -AsSecureString)
   Set-ADUser <user> -ChangePasswordAtLogon $true
   ```
4. Ask the user to sign out and sign in again. Confirm.

## Prevention
Check whether a phone, a network drive or a program has the old password saved.
