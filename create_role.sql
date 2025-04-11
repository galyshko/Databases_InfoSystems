-- Створення ролі admin
CREATE ROLE admin WITH PASSWORD 'admin';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;

-- Створення ролі moderator
CREATE ROLE moderator WITH PASSWORD 'moderator';
GRANT SELECT, UPDATE, INSERT ON ALL TABLES IN SCHEMA public TO moderator;

-- Створення ролі customer
CREATE ROLE customer;
GRANT SELECT ON Products, Categories TO customer;
GRANT SELECT, INSERT, UPDATE ON Orders, OrderItems, Payments TO customer;