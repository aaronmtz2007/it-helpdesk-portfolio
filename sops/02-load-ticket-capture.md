# SOP 02: Load ticket capture

🇪🇸 [Versión en español](02-load-ticket-capture.es.md)

**Purpose:** every delivered load becomes one ticket with correct data, so billing, driver pay and the dashboard can trust it.
**Owner:** operations coordinator · **Frequency:** after every delivery

## What you need for each load
- The scale ticket: gross weight (truck with the load) and tare weight (empty truck)
- Departure and arrival times
- Miles from the odometer and gallons from the fuel log
- The driver, the truck and the purchase order

## Steps
1. Open the **New load ticket** form (workflow 01).
2. Fill in every field. Times are in Eastern Time, 24-hour format (for example 06:30).
3. Submit. The result screen shows the ticket number, the tons, the hours on the road, the mpg and the driver pay.
4. If the form says "Please check the form", read the message, fix that field and send it again. Nothing is saved when there is an error.
5. Write the ticket number (LT-xxxxx) next to the paper scale ticket.

## What the form checks
- Arrival time after departure time
- Gross weight higher than tare weight
- Miles and fuel greater than zero
- Times written as HH:MM

## Weekly review (Monday)
Open the dashboard and look at **Fuel use per driver, by week** and **Tons per hour by driver**. If one driver's mpg drops by more than 15 % compared with the previous weeks, check the truck and talk to the driver.
