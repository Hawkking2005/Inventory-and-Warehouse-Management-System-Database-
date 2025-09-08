- Drop tables if they exist to ensure a clean setup
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Warehouses;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS LowStockAlerts;

-- Create the Suppliers table
-- This table stores information about the suppliers of the products.
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

-- Create the Warehouses table
-- This table stores information about the different warehouse locations.
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);

-- Create the Products table
-- This table contains details for each product.
-- It includes a supplier_id to link products to their suppliers.
-- reorder_level is the minimum quantity before a reorder is needed.
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    supplier_id INT,
    reorder_level INT DEFAULT 10,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Create the Stock table (junction table)
-- This table tracks the quantity of each product in each warehouse.
-- It uses a composite primary key (product_id, warehouse_id) to ensure
-- that each product has only one stock entry per warehouse.
CREATE TABLE Stock (
    product_id INT,
    warehouse_id INT,
    quantity INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id, warehouse_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);

-- Create the LowStockAlerts table
-- This table will be used by the trigger to log low stock events.
CREATE TABLE LowStockAlerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    warehouse_id INT,
    alert_message VARCHAR(255),
    alert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);
