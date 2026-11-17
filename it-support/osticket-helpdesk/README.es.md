# Sistema de tickets Help Desk con osTicket

🇺🇸 [Read in English](README.md) · Guía: [English](GUIDE.md) · [Español](GUIDE.es.md)

Una mesa de ayuda pequeña que armé con osTicket, corriendo en Docker en mi propia PC, para practicar el ciclo completo de soporte: recibir un ticket, clasificarlo, priorizarlo, resolverlo, documentarlo y cerrarlo. El contenido dentro de osTicket (departamentos, tickets, plantillas, artículos) está en español. Los usuarios y los tickets son ficticios, pero se parecen a lo que manejo en mi trabajo actual.

**Estado:** 🟡 casi listo (falta el video) · **Tiempo invertido:** unas 5 h · **Fecha:** noviembre 2026

## Entorno

| Parte | Detalle |
|---|---|
| osTicket | v1.14.3, de la imagen de Docker `campbellsoftwaresolutions/osticket` |
| Base de datos | MariaDB 10.11 |
| Despliegue | Docker Compose en Windows 11, [`docker-compose.yml`](docker-compose.yml) + [`.env.example`](.env.example) |
| Acceso | `http://localhost:8080` (usuarios) · `http://localhost:8080/scp` (agentes) |

## Qué hice

- [x] Instalé osTicket y MariaDB con Docker Compose
- [x] 3 departamentos: Soporte TI, Redes, Impresoras y periféricos
- [x] 4 planes de SLA: Crítico (1 h), Alto (4 h), Normal (24 h), Bajo (72 h)
- [x] 7 temas de ayuda, cada uno ligado a un departamento, un SLA y una prioridad
- [x] 4 plantillas de respuesta ([textos](canned-responses.es.md))
- [x] 2 agentes (Aaron y Laura) con acceso a distintos departamentos
- [x] 10 tickets simulados, todos cerrados ([detalle](simulated-tickets.es.md))
- [x] Transferí un ticket entre departamentos y dejé vencer otro por SLA
- [x] 4 artículos de la base de conocimiento ([`kb/`](kb/))

## Capturas

Las capturas se ven paso a paso en la [guía](GUIDE.es.md). Están en [`evidence/`](evidence/).

| Paso | Captura |
|---|---|
| Panel de agentes | `01-dashboard.png` |
| Departamentos | `02-departments.png` |
| Planes de SLA | `03-sla-plans.png` |
| Temas de ayuda | `04-help-topics.png` |
| Plantillas de respuesta | `05-canned-responses.png` |
| Agentes | `06-agents.png` |
| Ticket 1 (Soporte TI) | `07-ticket-1a.png`, `07-ticket-1b.png` |
| Ticket 2 (Impresoras) | `08-ticket-2a.png`, `08-ticket-2b.png` |
| Ticket 3 (Redes) | `09-ticket-3a.png`, `09-ticket-3b.png` |
| Transferencia entre departamentos | `10-transfer-a.png`, `10-transfer-b.png` |
| Ticket vencido por SLA | `11-overdue-a.png`, `11-overdue-b.png` |
| Tickets cerrados | `12-closed-list.png` |
| Base de conocimiento | `13-kb-faqs.png`, `13-kb-article.png` |

## Problemas que tuve y cómo los resolví

1. **Docker Desktop decía "Virtual Machine Platform is not enabled".** Esa característica de Windows estaba apagada. La activé con PowerShell y reinicié.
2. **Al principio instalé el paquete equivocado de Docker.** `winget install Docker.sbx` no era Docker Desktop. Lo desinstalé e instalé `Docker.DockerDesktop`.
3. **El instalador web de osTicket no existía.** Esta imagen instala osTicket sola en el primer arranque, con variables de entorno del compose. Lo descubrí leyendo el script de arranque de la imagen y arreglé el compose.
4. **osTicket rechazaba los correos `.local`.** `laura.soporte@lab.local` y `admin@lab.local` daban "Valid email is required". Usé direcciones `example.com`, que están reservadas para ejemplos.
5. **"Contacta al administrador" al crear un ticket.** El ticket se creaba igual; el error era que osTicket no podía mandar los correos de aviso porque el lab no tiene servidor de correo (`mail() returned failure` en los logs). No afecta a los tickets.
6. **"Check Ticket Status" pedía un enlace por correo.** Sin correo, el enlace nunca llega. Desactivé "Require email verification on Check Ticket Status" en Settings → Users, y así el usuario entra con su correo y el número de ticket.
7. **"Lock denied" en un ticket.** osTicket bloquea el ticket para el agente que lo abre, así que mis dos sesiones de agente se estorbaban. Usé una ventana privada para el segundo agente.
8. **Aaron no veía los tickets de Redes.** Los agentes solo ven los departamentos a los que tienen acceso. Le agregué Redes como acceso extendido.
9. **No podía dejar un ticket vencido.** osTicket no acepta una fecha de vencimiento pasada. La puse unos minutos adelante y una tarea programada (corre cada 5 minutos) lo marcó como vencido. osTicket además muestra la hora en UTC, seis horas adelante de mi PC.

## Qué aprendí

- Un ticket sirve más cuando tiene estructura: equipo, descripción, mensaje de error, desde cuándo e impacto. El triage y la solución van en notas internas, y el usuario solo ve las respuestas.
- El SLA depende del tema de ayuda, no de la prioridad, así que un ticket realmente urgente necesita que le cambie el SLA a mano.
- Los agentes solo ven los departamentos a los que tienen acceso, así que los permisos importan hasta en un lab.
- Gran parte del tiempo se fue en pequeños detalles de configuración que ninguna guía menciona. Apuntarlos al momento hizo este README mucho más fácil.

## Cómo usé la IA

Usé un asistente de IA para ahorrar tiempo en algunas tareas, sobre todo para consultar comandos y ajustes. El sistema lo armé yo, creé y resolví los tickets, arreglé los errores y tomé las capturas.

## Relación con el Proyecto 1

Los tickets 1, 6 y 7 se resuelven en el [laboratorio de Active Directory](../active-directory-lab/): un desbloqueo de cuenta, un usuario nuevo y un permiso de grupo.
