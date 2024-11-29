
CREATE DATABASE IF NOT EXISTS mydatabase;
USE mydatabase;

-- Add your table creation and other SQL commands below
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,city VARCHAR(255) NOT NULL,
);
-- Create a table for orders
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert sample data into users table
INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com' ,'New York'),
('Bob', 'bob@example.com' ,'Los Angeles'),
('Charlie', 'charlie@example.com' ,'Chicago')
('David', 'david@gmail.com' ,'San Francisco');

-- Insert sample data into orders table
INSERT INTO orders (user_id, product_name, quantity) VALUES
(1, 'Laptop', 1),
(2, 'Smartphone', 2),
(3, 'Headphones', 1);

-- Verify data
SELECT * FROM users;
SELECT * FROM orders;
