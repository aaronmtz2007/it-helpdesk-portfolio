# SOP 04: Lead intake and follow-up

🇪🇸 [Versión en español](04-lead-intake-and-follow-up.es.md)

**Purpose:** no lead is forgotten. Every business that could become a customer is in one place with a next action and a date.
**Owner:** operations coordinator · **Frequency:** whenever a lead appears, and every weekday morning

## Steps
1. Open the **New lead** form (workflow 04). Enter the company, the contact name, the region, the source and the language to write in (Spanish for the Caribbean).
2. The lead is saved as "new" with a first call set for the next day.
3. Every weekday at 8:00 AM ET an email lists the leads whose follow-up is due today or overdue (workflow 05). Each one comes with a suggested message in the lead's language.
4. Make the call or send the message.
5. Update the stage and the next action date. The stages are: new, contacted, quoted, won, lost.
6. On the dashboard, **Leads by stage** shows how the pipeline looks.

## Limits of this lab
Stage changes are made directly in the database table `leads`. A real company would use a CRM for this step (for example NocoDB or HubSpot) so the team can edit leads from a screen.
