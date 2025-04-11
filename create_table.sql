CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
	phone NUMERIC(10) NOT NULL
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 0,
    price NUMERIC(10,2)
);

CREATE TABLE deliveries (
    delivery_id SERIAL PRIMARY KEY,
    supplier_id INT REFERENCES suppliers(supplier_id),
    product_id INT REFERENCES products(product_id),
    delivery_date DATE,
    delivered_quantity INT
);

