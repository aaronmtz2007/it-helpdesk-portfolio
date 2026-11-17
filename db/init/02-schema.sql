-- Business data for a fictional recycling company (all data is made up).
-- Time stamps are stored with time zone, so the Eastern Time cutoff works from anywhere.

CREATE TABLE drivers (
    driver_id       SERIAL PRIMARY KEY,
    name            TEXT NOT NULL,
    hourly_rate     NUMERIC(6,2) NOT NULL,   -- USD per hour on the road
    per_load_rate   NUMERIC(6,2) NOT NULL,   -- USD bonus for each load delivered
    active          BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE trucks (
    truck_id        SERIAL PRIMARY KEY,
    unit_code       TEXT NOT NULL UNIQUE,
    plate           TEXT NOT NULL,
    region          TEXT NOT NULL            -- Pacific Northwest or Florida
);

CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    name            TEXT NOT NULL,
    region          TEXT NOT NULL
);

CREATE TABLE purchase_orders (
    po_id           SERIAL PRIMARY KEY,
    customer_id     INT NOT NULL REFERENCES customers(customer_id),
    po_number       TEXT NOT NULL UNIQUE,
    material        TEXT NOT NULL,
    price_per_ton   NUMERIC(8,2) NOT NULL,
    status          TEXT NOT NULL DEFAULT 'open'
);

CREATE TABLE load_tickets (
    ticket_id       SERIAL PRIMARY KEY,
    ticket_no       TEXT NOT NULL UNIQUE,
    driver_id       INT NOT NULL REFERENCES drivers(driver_id),
    truck_id        INT NOT NULL REFERENCES trucks(truck_id),
    po_id           INT NOT NULL REFERENCES purchase_orders(po_id),
    gross_lb        INT NOT NULL,            -- weight with the load, from the scale
    tare_lb         INT NOT NULL,            -- weight of the empty truck
    departed_at     TIMESTAMPTZ NOT NULL,
    arrived_at      TIMESTAMPTZ NOT NULL,
    miles           NUMERIC(6,1) NOT NULL,
    fuel_gal        NUMERIC(6,1) NOT NULL,
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (arrived_at > departed_at),
    CHECK (gross_lb > tare_lb)
);

CREATE TABLE invoices (
    invoice_id      SERIAL PRIMARY KEY,
    invoice_no      TEXT NOT NULL UNIQUE,
    po_id           INT NOT NULL REFERENCES purchase_orders(po_id),
    issue_date      DATE NOT NULL,
    amount          NUMERIC(10,2) NOT NULL,
    status          TEXT NOT NULL DEFAULT 'pending',   -- pending, entered, paid
    entered_at      TIMESTAMPTZ
);

CREATE TABLE leads (
    lead_id         SERIAL PRIMARY KEY,
    company         TEXT NOT NULL,
    contact         TEXT,
    region          TEXT NOT NULL,
    source          TEXT NOT NULL,
    stage           TEXT NOT NULL DEFAULT 'new',       -- new, contacted, quoted, won, lost
    next_action     TEXT,
    next_action_date DATE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- One row per load with everything calculated.
-- Driver pay rule (fictional): hourly rate x trip hours + the per-load bonus.
CREATE VIEW v_load_metrics AS
SELECT
    t.ticket_id,
    t.ticket_no,
    d.name                                              AS driver,
    tr.unit_code                                        AS truck,
    c.name                                              AS customer,
    po.po_number,
    po.material,
    (t.gross_lb - t.tare_lb)                            AS net_lb,
    ROUND((t.gross_lb - t.tare_lb) / 2000.0, 2)         AS net_tons,
    t.departed_at,
    t.arrived_at,
    ROUND(EXTRACT(EPOCH FROM (t.arrived_at - t.departed_at)) / 3600.0, 2) AS trip_hours,
    t.miles,
    t.fuel_gal,
    ROUND(t.miles / NULLIF(t.fuel_gal, 0), 2)           AS mpg,
    ROUND(d.hourly_rate * EXTRACT(EPOCH FROM (t.arrived_at - t.departed_at)) / 3600.0
          + d.per_load_rate, 2)                         AS driver_pay,
    ROUND((t.gross_lb - t.tare_lb) / 2000.0 * po.price_per_ton, 2) AS revenue
FROM load_tickets t
JOIN drivers d          ON d.driver_id = t.driver_id
JOIN trucks tr          ON tr.truck_id = t.truck_id
JOIN purchase_orders po ON po.po_id = t.po_id
JOIN customers c        ON c.customer_id = po.customer_id;

-- Comparison between drivers.
CREATE VIEW v_driver_performance AS
SELECT
    driver,
    COUNT(*)                                  AS loads,
    ROUND(SUM(net_tons), 1)                   AS total_tons,
    ROUND(AVG(trip_hours), 2)                 AS avg_trip_hours,
    ROUND(SUM(miles) / NULLIF(SUM(fuel_gal), 0), 2) AS avg_mpg,
    ROUND(SUM(net_tons) / NULLIF(SUM(trip_hours), 0), 2) AS tons_per_hour,
    ROUND(SUM(driver_pay), 2)                 AS total_pay
FROM v_load_metrics
GROUP BY driver;

-- Totals per day, in Eastern Time.
CREATE VIEW v_daily_summary AS
SELECT
    (departed_at AT TIME ZONE 'America/New_York')::date AS day,
    COUNT(*)                         AS loads,
    ROUND(SUM(net_tons), 1)          AS total_tons,
    ROUND(SUM(fuel_gal), 1)          AS fuel_gal,
    ROUND(SUM(revenue), 2)           AS revenue,
    ROUND(SUM(driver_pay), 2)        AS driver_pay
FROM v_load_metrics
GROUP BY 1;

-- Invoices still waiting to be entered in the factoring portal.
CREATE VIEW v_pending_invoices AS
SELECT i.invoice_no, c.name AS customer, po.po_number, i.issue_date, i.amount
FROM invoices i
JOIN purchase_orders po ON po.po_id = i.po_id
JOIN customers c        ON c.customer_id = po.customer_id
WHERE i.status = 'pending';
