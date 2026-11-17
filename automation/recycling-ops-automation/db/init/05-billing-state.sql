-- Loads older than a week were already billed. Only the recent ones are waiting for an invoice.
UPDATE load_tickets SET invoiced = TRUE WHERE departed_at < now() - interval '7 days';
