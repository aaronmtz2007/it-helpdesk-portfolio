# Plantillas de respuesta (Canned Responses)

🇺🇸 [English version](canned-responses.md)

## Ticket recibido
```
Hola %{ticket.name.first},

Recibimos tu solicitud (ticket #%{ticket.number}). Un agente la revisará de acuerdo con su prioridad y te responderemos por este medio.

Saludos,
Soporte TI
```

## Solicitamos más información
```
Hola %{ticket.name.first},

Para ayudarte necesitamos más datos:
- ¿Desde cuándo ocurre el problema?
- ¿Aparece algún mensaje de error? Si puedes, envía una captura.
- ¿Qué equipo estás usando?

Gracias,
Soporte TI
```

## Resuelto: confirma por favor
```
Hola %{ticket.name.first},

Ya realizamos los cambios necesarios. Por favor confirma que todo funciona. Si no recibimos respuesta en 48 horas, cerraremos el ticket.

Saludos,
Soporte TI
```

## Cierre por falta de respuesta
```
Hola %{ticket.name.first},

Cerramos el ticket #%{ticket.number} porque no recibimos respuesta. Si el problema continúa, responde este mensaje y lo reabrimos.

Saludos,
Soporte TI
```
