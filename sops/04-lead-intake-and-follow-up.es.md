# SOP 04: Alta y seguimiento de prospectos

🇺🇸 [English version](04-lead-intake-and-follow-up.md)

**Objetivo:** que no se olvide ningún prospecto. Cada negocio que podría ser cliente está en un solo lugar con una siguiente acción y una fecha.
**Responsable:** coordinación de operaciones · **Frecuencia:** cuando aparece un prospecto, y cada mañana de día hábil

## Pasos
1. Abrir el formulario **New lead** (flujo 04). Capturar la empresa, el nombre del contacto, la región, la fuente y el idioma en que se le escribe (español para el Caribe).
2. El prospecto se guarda como "new" con una primera llamada para el día siguiente.
3. Cada día hábil a las 8:00 AM ET llega un correo con los prospectos cuyo seguimiento vence hoy o ya venció (flujo 05). Cada uno trae un mensaje sugerido en su idioma.
4. Hacer la llamada o mandar el mensaje.
5. Actualizar la etapa y la fecha de la siguiente acción. Las etapas son: new, contacted, quoted, won, lost.
6. En el dashboard, **Leads by stage** muestra cómo va el embudo.

## Límites de este lab
Los cambios de etapa se hacen directo en la tabla `leads` de la base de datos. Una empresa real usaría un CRM para este paso (por ejemplo NocoDB o HubSpot), para que el equipo edite los prospectos desde una pantalla.
