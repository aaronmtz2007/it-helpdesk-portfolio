# Help Desk Ticketing System with osTicket

🇪🇸 [Leer en español](README.es.md) · Guide: [English](GUIDE.md) · [Español](GUIDE.es.md)

A small help desk I set up with osTicket, running in Docker on my own PC, to practice the full support cycle: receive a ticket, classify it, prioritize it, solve it, document it and close it. The content inside osTicket (departments, tickets, templates, articles) is in Spanish. All the users and tickets are fictional, but they are close to what I deal with at my current job.

**Status:** 🟡 almost done (video pending) · **Time spent:** about 5 h · **Date:** November 2026

## Setup

| Part | Detail |
|---|---|
| osTicket | v1.14.3, from the `campbellsoftwaresolutions/osticket` Docker image |
| Database | MariaDB 10.11 |
| Deployment | Docker Compose on Windows 11, [`docker-compose.yml`](docker-compose.yml) + [`.env.example`](.env.example) |
| Access | `http://localhost:8080` (users) · `http://localhost:8080/scp` (agents) |

## What I did

- [x] Installed osTicket and MariaDB with Docker Compose
- [x] 3 departments: Soporte TI, Redes, Impresoras y periféricos
- [x] 4 SLA plans: Crítico (1 h), Alto (4 h), Normal (24 h), Bajo (72 h)
- [x] 7 help topics, each linked to a department, an SLA plan and a priority
- [x] 4 canned responses ([texts](canned-responses.md))
- [x] 2 agents (Aaron and Laura) with access to different departments
- [x] 10 simulated tickets, all closed ([detail](simulated-tickets.md))
- [x] Transferred a ticket between departments and flagged one as overdue by SLA
- [x] 4 knowledge base articles ([`kb/`](kb/))

## Screenshots

The screenshots are shown step by step in the [guide](GUIDE.md). They are in [`evidence/`](evidence/).

| Step | Screenshot |
|---|---|
| Agent panel | `01-dashboard.png` |
| Departments | `02-departments.png` |
| SLA plans | `03-sla-plans.png` |
| Help topics | `04-help-topics.png` |
| Canned responses | `05-canned-responses.png` |
| Agents | `06-agents.png` |
| Ticket 1 (Soporte TI) | `07-ticket-1a.png`, `07-ticket-1b.png` |
| Ticket 2 (Impresoras) | `08-ticket-2a.png`, `08-ticket-2b.png` |
| Ticket 3 (Redes) | `09-ticket-3a.png`, `09-ticket-3b.png` |
| Transfer between departments | `10-transfer-a.png`, `10-transfer-b.png` |
| Ticket overdue by SLA | `11-overdue-a.png`, `11-overdue-b.png` |
| Closed tickets | `12-closed-list.png` |
| Knowledge base | `13-kb-faqs.png`, `13-kb-article.png` |

## Problems I ran into and how I fixed them

1. **Docker Desktop said "Virtual Machine Platform is not enabled".** That Windows feature was off. I enabled it with PowerShell and rebooted.
2. **I installed the wrong Docker package at first.** `winget install Docker.sbx` was not Docker Desktop. I uninstalled it and installed `Docker.DockerDesktop`.
3. **The osTicket web installer didn't exist.** This image installs osTicket by itself on the first start, using environment variables from the compose file. I found it by reading the image's start script and fixed the compose file.
4. **osTicket rejected `.local` emails.** `laura.soporte@lab.local` and `admin@lab.local` gave "Valid email is required". I used `example.com` addresses, which are reserved for examples.
5. **"Contact your administrator" when creating a ticket.** The ticket was created anyway; the error was osTicket failing to send alert emails because the lab has no mail server (`mail() returned failure` in the logs). It doesn't affect tickets.
6. **"Check Ticket Status" asked for an emailed link.** With no email, the link never arrives. I turned off "Require email verification on Check Ticket Status" in Settings → Users, so users can sign in with email and ticket number.
7. **"Lock denied" on a ticket.** osTicket locks a ticket for the agent who opens it, so my two agent sessions got in each other's way. I used a private window for the second agent.
8. **Aaron couldn't see tickets from Redes.** Agents only see departments they have access to. I added Redes as extended access.
9. **I couldn't make a ticket overdue.** osTicket won't accept a due date in the past. I set it a few minutes ahead and a scheduled task (it runs every 5 minutes) flagged it overdue. osTicket also shows times in UTC, six hours ahead of my PC.

## What I learned

- A ticket is more useful when it has structure: equipment, description, error message, since when and impact. Triage and solution go in internal notes, and the user only sees the replies.
- The SLA belongs to the help topic, not to the priority, so a really urgent ticket needs its SLA changed by hand.
- Agents only see the departments they have access to, so permissions matter even in a lab.
- Most of the time went into small setup details that no guide mentions. Writing them down as they happened made this README much easier.

## How I used AI

I used an AI assistant to save time on some tasks, mainly to check commands and settings. I set the system up, created and solved the tickets myself, fixed the errors and took the screenshots.

## Relation with project 1

Tickets 1, 6 and 7 are solved in the [Active Directory lab](../active-directory-lab/): an account unlock, a new user and a group permission.
