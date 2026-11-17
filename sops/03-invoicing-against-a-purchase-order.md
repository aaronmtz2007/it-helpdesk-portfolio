# SOP 03: Invoicing against a purchase order

🇪🇸 [Versión en español](03-invoicing-against-a-purchase-order.es.md)

**Purpose:** bill every delivered load to the customer against the right purchase order (PO), once and only once.
**Owner:** operations coordinator · **Frequency:** when a PO has delivered loads waiting to be billed

## Steps
1. Make sure all the deliveries of the PO are captured ([SOP 02](02-load-ticket-capture.md)).
2. Open the **Create an invoice** form (workflow 03) and pick the PO number.
3. The system groups all the loads of that PO that were not billed yet into one invoice. The amount is the total tons times the price per ton of the PO.
4. The result screen shows the invoice number, the loads, the tons and the amount. The invoice is emailed to the customer (in this lab it goes to a test inbox).
5. The invoice is now pending. The next morning's reminder will list it ([SOP 01](01-daily-invoice-entry.md)).

## Good to know
- Invoice numbers are sequential and are never reused.
- Payment terms are net 30 days.
- If the form says "Nothing to invoice", the PO has no loads waiting. Check whether the load tickets were captured.
- To see what is ready to be billed before invoicing, use the view `v_ready_to_invoice` (it can also be added to the dashboard).
