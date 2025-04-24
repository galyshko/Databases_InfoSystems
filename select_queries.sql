-- Вибірка всіх користувачів
SELECT * FROM Users;

-- Вибірка всіх продуктів
SELECT * FROM Products;

-- Вибірка всіх замовлень
SELECT * FROM Orders;



-- Користувачі з роллю 'admin'
SELECT * FROM Users WHERE role = 'admin';

-- Продукти з ціною більше 50
SELECT * FROM Products WHERE price > 50;

-- Замовлення зі статусом 'completed'
SELECT * FROM Orders WHERE status = 'completed';



-- Продукти, відсортовані за ціною (від найдешевших)
SELECT * FROM Products ORDER BY price ASC;

-- Користувачі, відсортовані за іменем (алфавітний порядок)
SELECT * FROM Users ORDER BY username;

-- Замовлення, відсортовані за датою (від найновіших)
SELECT * FROM Orders ORDER BY order_date DESC;



-- Кількість користувачів кожної ролі
SELECT role, COUNT(*) as user_count 
FROM Users 
GROUP BY role;

-- Категорії з більш ніж 5 продуктами
SELECT category_id, COUNT(*) as product_count 
FROM Products 
GROUP BY category_id 
HAVING COUNT(*) > 5;

-- Клієнти з більш ніж 2 замовленнями
SELECT user_id, COUNT(*) as order_count 
FROM Orders
GROUP BY user_id 
HAVING COUNT(*) > 2;



-- Інформація про замовлення разом з даними користувача
SELECT o.*, u.username, u.email 
FROM Orders o
JOIN Users u ON o.user_id = u.id;

-- Продукти з назвами їх категорій
SELECT p.*, c.name as category_name 
FROM Products p
JOIN Categories c ON p.category_id = c.id;



-- Загальна кількість користувачів
SELECT COUNT(*) as total_users FROM Users;

-- Середня ціна продуктів
SELECT AVG(price) as average_price FROM Products;

-- Сума всіх платежів
SELECT SUM(amount) as total_payments FROM Payments;



-- Унікальні ролі користувачів
SELECT DISTINCT role FROM Users;

-- Унікальні статуси замовлень
SELECT DISTINCT status FROM Orders;



-- Максимальна і мінімальна ціна продуктів
SELECT MAX(price) as max_price, MIN(price) as min_price FROM Products;

-- Найбільша і найменша кількість товару на складі
SELECT MAX(stock_quantity) as max_stock, MIN(stock_quantity) as min_stock FROM Products;



--Cередня кількість замовлень на клієнта, які робили замовлення
SELECT AVG(order_count) as avg_orders_per_user
FROM (
    SELECT user_id, COUNT(*) as order_count 
    FROM Orders 
    GROUP BY user_id
) as user_orders;



-- Кількість активних продуктів (з кількістю на складі > 0)
SELECT COUNT(*) as active_products 
FROM Products 
WHERE stock_quantity > 0;

-- Кількість замовлень у статусі "in processing"
SELECT COUNT(*) as processing_orders 
FROM Orders 
WHERE status = 'in processing';



--загальна сума всіх транзакцій
SELECT SUM(amount) as total_transactions 
FROM Payments;



--Продукти, що є в базі даних
SELECT id, name, price, stock_quantity 
FROM Products;



-- Продукти з максимальною ціною
SELECT * FROM Products 
WHERE price = (SELECT MAX(price) FROM Products);

-- Продукти з мінімальною ціною
SELECT * FROM Products 
WHERE price = (SELECT MIN(price) FROM Products);



--Кількість замовлень для кожного клієнта
SELECT u.id, u.username, COALESCE(COUNT(o.id), 0) as order_count
FROM Users u
LEFT JOIN Orders o ON u.id = o.user_id
GROUP BY u.id, u.username;



-- Продано товарів за певний період
SELECT SUM(oi.quantity) as total_items_sold
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.id
WHERE o.order_date >= '2025-03-10' AND o.order_date <= '2025-04-12';



--Найпопулярніші категорії
SELECT c.name, COUNT(oi.id) as order_count
FROM Categories c
JOIN Products p ON c.id = p.category_id
JOIN OrderItems oi ON p.id = oi.product_id
GROUP BY c.name
ORDER BY order_count DESC;


-- Клієнт, що зробив найбільшу кількість покупок
SELECT u.id, u.username, COUNT(o.id) as order_count
FROM Users u
JOIN Orders o ON u.id = o.user_id
GROUP BY u.id, u.username
ORDER BY order_count DESC
LIMIT 1;



-- -- Продукти з найменшою кількістю продажів
SELECT p.id, p.name, COUNT(oi.id) as order_count
FROM Products p
LEFT JOIN OrderItems oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY order_count ASC
LIMIT 5;



--Замовлень де сума > 1000
SELECT COUNT(*) as orders_over_1000
FROM (
    SELECT o.id, SUM(oi.quantity * oi.price) as order_total
    FROM Orders o
    JOIN OrderItems oi ON o.id = oi.order_id
    GROUP BY o.id
    HAVING SUM(oi.quantity * oi.price) > 1000
) as expensive_orders;



--Сума продажів за останній місяць
SELECT SUM(oi.quantity * oi.price) as total_sales
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.id
WHERE o.order_date >= '2025-03-10' AND o.order_date <= '2025-04-12';



--Замовлень з певними статусами
SELECT status, COUNT(*) as order_count
FROM Orders
GROUP BY status;