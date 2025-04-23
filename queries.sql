--1. Створення користувацького типу даних
-- Створення користувацького типу ENUM для статусу замовлення
CREATE TYPE order_status_type AS ENUM ('new', 'in processing', 'completed', 'cancelled');

-- Зміна типу стовпця status у таблиці Orders
ALTER TABLE Orders ALTER COLUMN status TYPE order_status_type USING status::order_status_type;


--2. Створення користувацької функції
-- Функція для розрахунку доходу за період
CREATE OR REPLACE FUNCTION calculate_revenue(start_date TIMESTAMP, end_date TIMESTAMP)
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    total_revenue DECIMAL(10, 2);
BEGIN
    SELECT COALESCE(SUM(total_amount), 0) INTO total_revenue
    FROM Orders
    WHERE order_date BETWEEN start_date AND end_date
    AND status = 'completed';
    
    RETURN total_revenue;
END;
$$ LANGUAGE plpgsql;

-- Приклад використання функції
SELECT calculate_revenue('2024-01-01', '2025-01-01') AS yearly_revenue;


--3.  Створення тригерів
-- Створення таблиці для логування змін
CREATE TABLE order_logs (
    log_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    changed_field VARCHAR(50),
    old_value TEXT,
    new_value TEXT,
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100)
);

-- Тригерна функція для логування змін
CREATE OR REPLACE FUNCTION log_order_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO order_logs (order_id, changed_field, new_value, changed_by)
        VALUES (NEW.id, 'NEW ORDER', 'Created', current_user);
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.status <> OLD.status THEN
            INSERT INTO order_logs (order_id, changed_field, old_value, new_value, changed_by)
            VALUES (NEW.id, 'status', OLD.status, NEW.status, current_user);
        END IF;
        
        IF NEW.total_amount <> OLD.total_amount THEN
            INSERT INTO order_logs (order_id, changed_field, old_value, new_value, changed_by)
            VALUES (NEW.id, 'total_amount', OLD.total_amount::TEXT, NEW.total_amount::TEXT, current_user);
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO order_logs (order_id, changed_field, old_value, changed_by)
        VALUES (OLD.id, 'ORDER DELETED', 'Order deleted', current_user);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Додавання тригера до таблиці Orders
CREATE TRIGGER orders_change_log
AFTER INSERT OR UPDATE OR DELETE ON Orders
FOR EACH ROW EXECUTE FUNCTION log_order_changes();

-- Тригерна функція для оновлення запасів
CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF (SELECT stock_quantity FROM Products WHERE id = NEW.product_id) < NEW.quantity THEN
            RAISE EXCEPTION 'Недостатньо товару на складі';
        END IF;
        UPDATE Products SET stock_quantity = stock_quantity - NEW.quantity WHERE id = NEW.product_id;
    ELSIF TG_OP = 'UPDATE' THEN
        IF (SELECT stock_quantity FROM Products WHERE id = NEW.product_id) + OLD.quantity < NEW.quantity THEN
            RAISE EXCEPTION 'Недостатньо товару на складі';
        END IF;
        UPDATE Products SET stock_quantity = stock_quantity + OLD.quantity - NEW.quantity WHERE id = NEW.product_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE Products SET stock_quantity = stock_quantity + OLD.quantity WHERE id = OLD.product_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Додавання тригера до таблиці OrderItems
CREATE TRIGGER order_items_stock_update
AFTER INSERT OR UPDATE OR DELETE ON OrderItems
FOR EACH ROW EXECUTE FUNCTION update_product_stock();


--5. Перевірка роботи
-- Спроба встановити недопустимий статус
UPDATE Orders SET status = 'invalid_status' WHERE id = 1;  -- Це викличе помилку

-- Встановлення допустимого статусу
UPDATE Orders SET status = 'new' WHERE id = 1;  -- Працює коректно

-- Перевірка доходу за 2024 рік
SELECT calculate_revenue('2024-01-01', '2024-12-31') AS yearly_revenue;

-- Перевірка логування змін
UPDATE Orders SET status = 'completed' WHERE id = 1;
SELECT * FROM order_logs WHERE order_id = 1;

-- Перевірка оновлення запасів
INSERT INTO OrderItems (order_id, product_id, quantity, price) 
VALUES (1, 1, 2, 12.99); -- з помилкою

-- Перевірка оновлення запасів
INSERT INTO OrderItems (order_id, product_id, quantity, price) 
VALUES (1, 5, 2, 12.99);

SELECT id, name, stock_quantity FROM Products WHERE id = 5;  -- Має зменшитись на 2

-- Спочатку знайдемо id доданого елемента замовлення
SELECT * FROM OrderItems WHERE order_id = 1 AND product_id = 5;

--Оновляємо замовлення
UPDATE OrderItems SET quantity = 4 WHERE id = 52;

SELECT id, name, stock_quantity FROM Products WHERE id = 5;

-- Видаляємо елемент замовлення
DELETE FROM OrderItems WHERE id = 52;

SELECT id, name, stock_quantity FROM Products WHERE id = 5;