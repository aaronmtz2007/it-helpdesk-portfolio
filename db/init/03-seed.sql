-- Fictional starting data. Every name, plate and number is made up.

INSERT INTO drivers (name, hourly_rate, per_load_rate) VALUES
 ('Marcus Reed',  31.50, 18.00),
 ('Ana Torres',   30.00, 18.00),
 ('Luis Ortega',  29.00, 18.00),
 ('Dale Hughes',  32.00, 18.00),
 ('Rosa Medina',  30.00, 18.00),
 ('Tom Bennett',  28.50, 18.00);

INSERT INTO trucks (unit_code, plate, region) VALUES
 ('T-101', 'WA-4821', 'Pacific Northwest'),
 ('T-102', 'WA-5532', 'Pacific Northwest'),
 ('T-103', 'OR-3390', 'Pacific Northwest'),
 ('T-201', 'FL-7710', 'Florida'),
 ('T-202', 'FL-9054', 'Florida');

INSERT INTO customers (name, region) VALUES
 ('Cascade Metals Co.',     'Pacific Northwest'),
 ('Evergreen Steel Works',  'Pacific Northwest'),
 ('Sunshine Aluminum',      'Florida'),
 ('Gulf Coast Recyclers',   'Florida'),
 ('Pacific Paper Mill',     'Pacific Northwest');

INSERT INTO purchase_orders (customer_id, po_number, material, price_per_ton) VALUES
 (1, 'PO-24-0101', 'Mixed metals', 380.00),
 (2, 'PO-24-0102', 'Scrap steel',  245.00),
 (3, 'PO-24-0103', 'Aluminum',    1100.00),
 (4, 'PO-24-0104', 'Plastics',     160.00),
 (5, 'PO-24-0105', 'Cardboard',    110.00);

-- The load tickets are generated in 04-load-history.sql.

-- Ten invoices. The four newest are still waiting to be entered in the portal.
INSERT INTO invoices (invoice_no, po_id, issue_date, amount, status, entered_at)
SELECT
    'INV-' || (1000 + i),
    ((i - 1) % 5) + 1,
    current_date - i,
    ROUND((4500 + i * 730.5)::numeric, 2),
    CASE WHEN i <= 4 THEN 'pending' WHEN i <= 7 THEN 'entered' ELSE 'paid' END,
    CASE WHEN i > 4 THEN now() - (i * interval '1 day') END
FROM generate_series(1, 10) AS i;

INSERT INTO leads (company, contact, region, source, stage, next_action, next_action_date) VALUES
 ('Caribe Scrap Partners',    'Elena Cruz',    'Caribbean', 'Referral',   'contacted', 'Send price list in Spanish',      current_date),
 ('Santo Domingo Metales',    'Rafael Peña',   'Caribbean', 'Web search', 'new',       'First call',                      current_date),
 ('Isla Verde Recycling',     'Carmen Rivera', 'Caribbean', 'Trade show', 'quoted',    'Follow up on the quote',          current_date + 4),
 ('Tacoma Demolition',        'Jim Walker',    'Pacific Northwest', 'Cold call', 'new',       'Send intro email',            current_date + 1),
 ('Orlando Builders Supply',  'Sandra Lopez',  'Florida',   'Referral',   'contacted', 'Schedule a site visit',           current_date + 3),
 ('Tampa Bay Salvage',        'Mike Duran',    'Florida',   'Web search', 'lost',      NULL,                              NULL),
 ('Portland Roofing Co.',     'Anna Fischer',  'Pacific Northwest', 'Referral', 'won',        'Set up first delivery',       current_date + 5),
 ('Miami Port Logistics',     'Diego Marin',   'Florida',   'Trade show', 'quoted',    'Confirm weekly volume',           current_date + 2);

UPDATE leads SET language = 'Spanish' WHERE region = 'Caribbean';
