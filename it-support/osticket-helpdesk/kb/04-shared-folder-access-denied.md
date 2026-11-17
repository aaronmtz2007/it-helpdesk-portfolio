# Shared folder: "Access denied"

🇪🇸 [Versión en español](04-shared-folder-access-denied.es.md)

**Usual cause:** the user doesn't belong to the group that has permissions.

## Solution
1. Confirm with the manager that the access is authorized.
2. Add the user to the group:
   ```powershell
   Add-ADGroupMember -Identity GG_<Department> -Members <user>
   ```
3. On the user's computer: sign out and sign in again (the group token is refreshed at sign-in), or run `gpupdate /force`.
4. Test `\\DC01\<resource>`.
