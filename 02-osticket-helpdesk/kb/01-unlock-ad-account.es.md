# Cuenta de Active Directory bloqueada

🇺🇸 [English version](01-unlock-ad-account.md)

**Síntoma:** "La cuenta está bloqueada" al iniciar sesión.
**Causa habitual:** varios intentos con contraseña incorrecta (umbral de la política).

## Solución (agente)
1. Verificar identidad del usuario.
2. En el DC:
   ```powershell
   Search-ADAccount -LockedOut
   Unlock-ADAccount -Identity <usuario>
   ```
3. Si olvidó la contraseña:
   ```powershell
   Set-ADAccountPassword -Identity <usuario> -Reset -NewPassword (Read-Host -AsSecureString)
   Set-ADUser <usuario> -ChangePasswordAtLogon $true
   ```
4. Pedir al usuario cerrar sesión y volver a entrar. Confirmar.

## Prevención
Revisar si hay un teléfono, unidad de red o programa con la contraseña vieja guardada.
