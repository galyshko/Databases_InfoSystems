--Логічні оператори
--1. Отримати всіх користувачів з роллю 'admin' або 'moderator'
SELECT * FROM Users 
WHERE role = 'admin' OR role = 'moderator';

--2. Отримати продукти з ціною від 10 до 50, які є в наявності
SELECT * FROM Products 
WHERE price BETWEEN 10 AND 50 
AND stock_quantity > 0;

--3. Отримати замовлення зі статусом 'completed' і сумою більше 1000
SELECT * FROM Orders 
WHERE status = 'completed' 
AND total_amount > 1000;


--Агрегатні функції
--4. Підрахувати кількість користувачів
SELECT COUNT(*) AS user_count FROM Users;

--5. Знайти середню вартість продуктів
SELECT AVG(price) AS average_price FROM Products;

--6. Знайти мінімальну та максимальну ціну продуктів
SELECT MIN(price) AS min_price, MAX(price) AS max_price 
FROM Products;

--7. Підрахувати загальну кількість товарів на складі
SELECT SUM(stock_quantity) AS total_stock 
FROM Products;

--8. Знайти середню суму замовлення
SELECT AVG(total_amount) AS avg_order_amount 
FROM Orders;


--JOIN операції
--9. INNER JOIN: Отримати інформацію про замовлення з деталями користувачів
SELECT o.id, u.username, u.email, o.order_date, o.total_amount 
FROM Orders o
INNER JOIN Users u ON o.user_id = u.id;

--10. LEFT JOIN: Отримати всі категорії та кількість продуктів у них
SELECT c.name, COUNT(p.id) AS product_count 
FROM Categories c
LEFT JOIN Products p ON c.id = p.category_id 
GROUP BY c.name;

--11. RIGHT JOIN: Отримати всі продукти та їх категорії
SELECT p.name, c.name AS category 
FROM Categories c
RIGHT JOIN Products p ON c.id = p.category_id;

--12. FULL JOIN: Отримати всі продукти та всі замовлення
SELECT p.name, oi.order_id 
FROM Products p
FULL JOIN OrderItems oi ON p.id = oi.product_id;

--13. CROSS JOIN: Отримати всі можливі комбінації користувачів та категорій
SELECT u.username, c.name AS category 
FROM Users u
CROSS JOIN Categories c;

--14. SELF JOIN: Отримати користувачів з однаковою роллю
SELECT a.username AS user1, b.username AS user2, a.role 
FROM Users a, Users b 
WHERE a.id < b.id AND a.role = b.role;


--Складні запити
--15. Підзапит у WHERE: Отримати продукти, які дорожчі за середню ціну
SELECT name, price 
FROM Products 
WHERE price > (SELECT AVG(price) FROM Products);

--16. Підзапит з IN: Отримати замовлення, які містять продукти з категорії 'Food'
SELECT o.* 
FROM Orders o
WHERE o.id IN (
    SELECT oi.order_id 
    FROM OrderItems oi
    JOIN Products p ON oi.product_id = p.id 
    JOIN Categories c ON p.category_id = c.id 
    WHERE c.name LIKE 'Food%'
);

--17. NOT EXISTS: Отримати користувачів без замовлень
SELECT u.* 
FROM Users u
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.user_id = u.id
);

--18. EXISTS: Отримати користувачів, які робили замовлення
SELECT u.* 
FROM Users u
WHERE EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.user_id = u.id
);

--19. UNION: Отримати всі унікальні імена продуктів та категорій
SELECT name FROM Products
UNION
SELECT name FROM Categories;

--20. INTERSECT: Отримати продукти, що замовлені, та мають статус 'completed' та 'in processing'
SELECT p.name
FROM Products p
JOIN OrderItems oi ON p.id = oi.product_id
JOIN Orders o ON oi.order_id = o.id
WHERE o.status = 'completed'
INTERSECT
SELECT p.name
FROM Products p
JOIN OrderItems oi ON p.id = oi.product_id
JOIN Orders o ON oi.order_id = o.id
WHERE o.status = 'in processing';

--21. EXCEPT: Отримати продукти в наявності, але ніколи не були замовлені
SELECT id, name 
FROM Products 
WHERE stock_quantity > 0
EXCEPT
SELECT p.id, p.name
FROM Products p
JOIN OrderItems oi ON p.id = oi.product_id;


--Common Table Expressions (CTE)
--22. CTE: Отримати користувачів з кількістю їхніх замовлень
WITH UserOrderCount AS (
    SELECT user_id, COUNT(*) AS order_count 
    FROM Orders 
    GROUP BY user_id
)
SELECT u.username, uoc.order_count 
FROM Users u
JOIN UserOrderCount uoc ON u.id = uoc.user_id;


--Віконні функції
--23. Пронумерувати продукти за ціною
SELECT 
    id, name, price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS price_rank
FROM Products;

--24. Рейтинг користувачів за сумою замовлень
SELECT 
    u.id, u.username,
    SUM(o.total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS user_rank
FROM Users u
JOIN Orders o ON u.id = o.user_id
GROUP BY u.id, u.username;

--25. Рейтинг категорій за середньою ціною продуктів
SELECT 
    c.name,
    AVG(p.price) AS avg_price,
    DENSE_RANK() OVER (ORDER BY AVG(p.price) DESC) AS category_rank
FROM Categories c
JOIN Products p ON c.id = p.category_id
GROUP BY c.name;

--26. Розподілити продукти на 4 групи за ціною
SELECT 
    name, price,
    NTILE(4) OVER (ORDER BY price) AS price_quartile
FROM Products;

--27. Порівняти ціни продуктів з попереднім/наступним
SELECT 
    name, price,
    LAG(price) OVER (ORDER BY price) AS prev_price,
    LEAD(price) OVER (ORDER BY price) AS next_price
FROM Products;

--28. Накопичувальна сума замовлень по датах
SELECT 
    id, order_date, total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) AS running_total
FROM Orders;


--Додаткові складні запити
--29. Отримати топ-5 користувачів за кількістю замовлень
SELECT u.id, u.username, COUNT(o.id) AS order_count 
FROM Users u
JOIN Orders o ON u.id = o.user_id
GROUP BY u.id, u.username
ORDER BY order_count DESC
LIMIT 5;

--30. Отримати продукти, які ніколи не замовлялися
SELECT p.* 
FROM Products p
LEFT JOIN OrderItems oi ON p.id = oi.product_id
WHERE oi.id IS NULL;

--31. Отримати загальну суму продажів по категоріях
SELECT c.name, SUM(oi.price * oi.quantity) AS total_sales 
FROM Categories c
JOIN Products p ON c.id = p.category_id
JOIN OrderItems oi ON p.id = oi.product_id
GROUP BY c.name
ORDER BY total_sales DESC;

--32.  Отримати середній чек за місяцями
SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    AVG(total_amount) AS avg_order_amount
FROM Orders
GROUP BY month
ORDER BY month;

--33. Отримати клієнтів, які робили замовлення вище середнього
SELECT u.*, o.total_amount 
FROM Users u
JOIN Orders o ON u.id = o.user_id
WHERE o.total_amount > (SELECT AVG(total_amount) FROM Orders);

--34. Отримати всі активні замовлення (не завершені)
SELECT o.id, u.username, o.order_date, o.total_amount, o.status
FROM Orders o
JOIN Users u ON o.user_id = u.id
WHERE o.status != 'completed'
ORDER BY o.order_date;

--35. Знайти продукти, які закінчуються на складі (менше 5 шт)
SELECT id, name, stock_quantity 
FROM Products
WHERE stock_quantity < 5
ORDER BY stock_quantity;

--36. Показати останні 10 замовлень
SELECT o.id, u.username, o.order_date, o.total_amount, o.status
FROM Orders o
JOIN Users u ON o.user_id = u.id
ORDER BY o.order_date DESC
LIMIT 10;

--37. Порахувати кількість замовлень по місяцях
SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    COUNT(*) AS orders_count
FROM Orders
GROUP BY month
ORDER BY month;

--38. Знайти користувачів без жодного замовлення
SELECT u.id, u.username, u.email
FROM Users u
LEFT JOIN Orders o ON u.id = o.user_id
WHERE o.id IS NULL;

--39. Отримати список продуктів з їх категоріями
SELECT p.id, p.name, p.price, c.name AS category
FROM Products p
LEFT JOIN Categories c ON p.category_id = c.id
ORDER BY c.name;

--40. Порахувати загальну суму продажів по кожному користувачу
SELECT u.id, u.username, SUM(o.total_amount) AS total_spent
FROM Users u
LEFT JOIN Orders o ON u.id = o.user_id
GROUP BY u.id, u.username
ORDER BY total_spent DESC NULLS LAST;