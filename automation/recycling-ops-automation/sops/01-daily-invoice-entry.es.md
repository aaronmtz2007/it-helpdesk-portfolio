# SOP 01: Captura diaria de facturas (antes de las 10:00 AM ET)

🇺🇸 [English version](01-daily-invoice-entry.md)

**Objetivo:** que todas las facturas estén en los portales de factoraje y del banco antes del corte de las 10:00 AM hora del Este, para que el pago llegue el mismo día.
**Responsable:** coordinación de operaciones · **Frecuencia:** todos los días hábiles

> Zona horaria: las 10:00 AM ET son las 9:00 AM en Campeche en invierno y las 8:00 AM en verano. El recordatorio llega a las 9:30 AM ET.

## Pasos
1. A las 9:30 AM ET llega el correo "N invoice(s) to enter before 10:00 AM ET" (flujo 02). Trae cada factura pendiente (número, cliente, orden de compra, monto) y el total.
2. Abrir el portal de factoraje y capturar cada factura de la lista.
3. Abrir el portal del banco y capturar las mismas facturas.
4. Comparar el total de cada portal con el total del correo. Si no coinciden, parar y buscar la factura que falta antes del corte.
5. Marcar cada factura como capturada con el formulario **Invoice entered in the portal** (flujo 06).
6. Revisar el dashboard: la tabla **Pending invoices** debe quedar vacía.

## Si algo sale mal
| Problema | Qué hacer |
|---|---|
| Falta una factura en el correo | Sus cargas todavía no se habían facturado. Seguir el [SOP 03](03-invoicing-against-a-purchase-order.es.md) |
| Un portal no funciona | Escribir al fundador antes de las 10:00 AM ET con la lista de facturas |
| Se pasó el corte | El pago llega el siguiente día hábil. Anotarlo y mencionarlo en el resumen del día |
