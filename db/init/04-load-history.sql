-- About 75 days of fictional load history, so the dashboard has something to show.
-- Busy weekdays, quiet Saturdays, very few Sundays. Each driver has a different
-- speed and fuel use. One story is planted on purpose: in the last 14 days,
-- Luis Ortega's fuel use gets about 25 % worse, the kind of thing a dashboard should catch.
SELECT setseed(0.37);

INSERT INTO load_tickets
    (ticket_id, ticket_no, driver_id, truck_id, po_id, gross_lb, tare_lb, departed_at, arrived_at, miles, fuel_gal)
SELECT
    i,
    'LT-' || lpad(i::text, 5, '0'),
    d_id, t_id, po_id,
    tare + net,
    tare,
    dep,
    dep + (miles / speed) * interval '1 hour',
    miles,
    ROUND((miles / mpg)::numeric, 1)
FROM (
    SELECT
        row_number() OVER (ORDER BY day, s) AS i,
        d_id, t_id, po_id,
        28000 + t_id * 500                                   AS tare,
        30000 + (random() * 14000)::int                      AS net,
        ((day::timestamp + (5 + (s - 1) * 2.2 + random() * 0.8) * interval '1 hour')
            AT TIME ZONE 'America/New_York')                 AS dep,
        ROUND((40 + random() * 120)::numeric, 1)             AS miles,
        (36 + d_id * 2 + random() * 4)                       AS speed,
        (5.2 + (d_id % 3) * 0.5 + random() * 0.6)
            * CASE WHEN d_id = 3 AND day > current_date - 14 THEN 0.75 ELSE 1 END AS mpg
    FROM (
        SELECT
            day, s,
            ((s + (day - date '2026-01-01')) % 6) + 1        AS d_id,
            ((s + (day - date '2026-01-01')) % 5) + 1        AS t_id,
            1 + floor(random() * 5)::int                     AS po_id
        FROM (
            SELECT
                d::date AS day,
                CASE EXTRACT(isodow FROM d)::int
                    WHEN 7 THEN (random() < 0.2)::int
                    WHEN 6 THEN floor(random() * 3)::int
                    ELSE 1 + floor(random() * 5)::int
                END AS n
            FROM generate_series(current_date - 74, current_date, interval '1 day') d
        ) days,
        LATERAL generate_series(1, n) AS s
    ) loads
) x;

SELECT setval(pg_get_serial_sequence('load_tickets', 'ticket_id'), (SELECT MAX(ticket_id) FROM load_tickets));
