# Canned responses

🇪🇸 [Versión en español](canned-responses.es.md)

The responses are written in Spanish inside osTicket. This is the English translation. The variables `%{ticket.name.first}` and `%{ticket.number}` are filled in by osTicket with the user's first name and the ticket number.

## Ticket recibido (Ticket received)
```
Hi %{ticket.name.first},

We received your request (ticket #%{ticket.number}). An agent will review it according to its priority and will reply to you through this channel.

Regards,
IT Support
```

## Solicitamos más información (We need more information)
```
Hi %{ticket.name.first},

To help you we need a few more details:
- Since when does the problem happen?
- Do you see any error message? If you can, send a screenshot.
- What computer are you using?

Thanks,
IT Support
```

## Resuelto: confirma por favor (Solved: please confirm)
```
Hi %{ticket.name.first},

We made the necessary changes. Please confirm that everything works. If we don't hear back in 48 hours, we will close the ticket.

Regards,
IT Support
```

## Cierre por falta de respuesta (Closed for no reply)
```
Hi %{ticket.name.first},

We closed ticket #%{ticket.number} because we didn't get a reply. If the problem continues, reply to this message and we will reopen it.

Regards,
IT Support
```
