INSERT INTO suppliers (name, contact_email, phone) VALUES
('Tech Supplies Co.', 'contact@techsupplies.com', 1231231234),
('Office Depot Ltd.', 'info@officedepot.com', 1112223333),
('Gadget World', 'sales@gadgetworld.com', 1112223334);

INSERT INTO products (name, quantity, price) VALUES
('Keyboard', 50, 15.99),
('Mouse', 100, 9.49),
('Monitor', 20, 120.00);

INSERT INTO deliveries (supplier_id, product_id, delivery_date, delivered_quantity) VALUES
(1, 1, '2025-04-01', 30),   -- Tech Supplies -> Keyboard
(2, 2, '2025-04-02', 50),   -- Office Depot -> Mouse
(3, 3, '2025-04-03', 10);   -- Gadget World -> Monitor
