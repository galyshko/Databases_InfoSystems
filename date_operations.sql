-- Вставка нових постачальників
INSERT INTO suppliers (name, contact_email, phone) VALUES
('Tech Supplies Co.', 'contact@techsupplies.com', 1234567890),
('New England', 'info@newengland.com', 2345678901),
('Gadget World', 'sales@gadgetworld.com', 3456789012);

-- Вибірка всіх постачальників
SELECT * FROM suppliers;

-- Вибірка всіх товарів
SELECT * FROM products;

-- Вибірка всіх доствок
SELECT * FROM deliveries;

--Отримуємо назву товару, кількість у поставці та дату, приєднуючи products до deliveries
SELECT p.name, d.delivered_quantity, d.delivery_date
FROM deliveries d
JOIN products p ON d.product_id = p.product_id;

-- Вибірка з фільтрацією, наприклад, постачальники з конкретним номером телефону
SELECT * FROM suppliers WHERE phone = 1234567890;

-- Оновлення номера телефону для конкретного постачальника
UPDATE suppliers
SET phone = 9876543210
WHERE supplier_id = 1;

--Збільшує кількість товару з product_id = 1 на 100 одиниць
UPDATE products
SET quantity = quantity + 100
WHERE product_id = 1;

-- Вибірка всіх товарів
SELECT * FROM products;

-- Вибірка всіх постачальників
SELECT * FROM suppliers;

-- Оновлення електронної пошти для постачальника "Office Depot Ltd."
UPDATE suppliers
SET contact_email = 'new_email@officedepot.com'
WHERE name = 'Office Depot Ltd.';

-- Вибірка всіх постачальників
SELECT * FROM suppliers;

-- Вибірка всіх доствок
SELECT * FROM deliveries;

-- Видалення доставки з певним id
DELETE FROM deliveries
WHERE delivery_id = 1;

-- Вибірка всіх доствок
SELECT * FROM deliveries;

-- Видалення постачальника з певним id
DELETE FROM suppliers
WHERE supplier_id = 5;

-- Видалення всіх постачальників, у яких номер телефону починається з 234
DELETE FROM suppliers
WHERE CAST(phone AS TEXT) LIKE '345%';

-- Вибірка всіх постачальників
SELECT * FROM suppliers;

-- Видалення зв'язків з таблиці deliveries
DELETE FROM deliveries WHERE supplier_id = 3;

-- Тепер можна видалити постачальника
DELETE FROM suppliers WHERE supplier_id = 3;

-- Вибірка всіх постачальників
SELECT * FROM suppliers;


