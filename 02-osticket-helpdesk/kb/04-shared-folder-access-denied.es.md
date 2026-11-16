# Carpeta compartida: "Acceso denegado"

🇺🇸 [English version](04-shared-folder-access-denied.md)

**Causa habitual:** el usuario no pertenece al grupo con permisos.

## Solución
1. Confirmar con el responsable que el acceso está autorizado.
2. Añadir al grupo:
   ```powershell
   Add-ADGroupMember -Identity GG_<Departamento> -Members <usuario>
   ```
3. En el equipo del usuario: cerrar sesión y volver a entrar (el token de grupos se renueva al iniciar sesión), o `gpupdate /force`.
4. Probar `\\DC01\<recurso>`.
