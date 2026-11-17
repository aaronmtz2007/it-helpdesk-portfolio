# SOP 03: Facturación contra una orden de compra

🇺🇸 [English version](03-invoicing-against-a-purchase-order.md)

**Objetivo:** cobrar cada carga entregada al cliente contra la orden de compra (PO) correcta, una sola vez.
**Responsable:** coordinación de operaciones · **Frecuencia:** cuando una PO tiene cargas entregadas pendientes de facturar

## Pasos
1. Comprobar que todas las entregas de la PO estén capturadas ([SOP 02](02-load-ticket-capture.es.md)).
2. Abrir el formulario **Create an invoice** (flujo 03) y elegir el número de PO.
3. El sistema junta todas las cargas de esa PO que no se han facturado en una sola factura. El monto es el total de toneladas por el precio por tonelada de la PO.
4. La pantalla de resultado muestra el número de factura, las cargas, las toneladas y el monto. La factura se envía por correo al cliente (en este lab llega a una bandeja de prueba).
5. La factura queda pendiente. El recordatorio de la mañana siguiente la incluirá ([SOP 01](01-daily-invoice-entry.es.md)).

## Conviene saber
- Los números de factura son consecutivos y no se reutilizan.
- Las condiciones de pago son a 30 días.
- Si el formulario dice "Nothing to invoice", la PO no tiene cargas pendientes. Revisar si se capturaron los tickets de carga.
- Para ver qué está listo para facturar antes de hacerlo, usar la vista `v_ready_to_invoice` (también se puede agregar al dashboard).
