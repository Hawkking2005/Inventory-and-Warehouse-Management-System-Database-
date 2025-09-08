-- Insert sample data into the Suppliers table
INSERT INTO Suppliers (supplier_name, contact_person, phone, email) VALUES
('Global Electronics', 'John Doe', '123-456-7890', 'john.doe@globalelectronics.com'),
('Office Supplies Co.', 'Jane Smith', '098-765-4321', 'jane.smith@officesupplies.com'),
('Industrial Parts Inc.', 'Peter Jones', '555-555-5555', 'peter.jones@industrialparts.com');

-- Insert sample data into the Warehouses table
INSERT INTO Warehouses (warehouse_name, location) VALUES
('Main Warehouse', 'New York, NY'),
('West Coast Distribution', 'Los Angeles, CA'),
('South Hub', 'Houston, TX');

-- Insert sample data into the Products table
INSERT INTO Products (product_name, description, price, supplier_id, reorder_level) VALUES
('Laptop Pro 15"', '15-inch professional laptop', 1200.00, 1, 10),
('Wireless Mouse', 'Ergonomic wireless mouse', 25.50, 1, 25),
('A4 Paper Ream', '500 sheets of A4 paper', 5.00, 2, 50),
('Industrial Bearing', 'Standard industrial-grade bearing', 15.75, 3, 20),
('Mechanical Keyboard', 'Backlit mechanical keyboard', 75.00, 1, 15);

-- Insert sample inventory records into the Stock table
INSERT INTO Stock (product_id, warehouse_id, quantity) VALUES
(1, 1, 12), -- Laptop Pro 15" in Main Warehouse
(1, 2, 5),  -- Laptop Pro 15" in West Coast (Low Stock)
(2, 1, 100),-- Wireless Mouse in Main Warehouse
(2, 3, 50), -- Wireless Mouse in South Hub
(3, 1, 200),-- A4 Paper Ream in Main Warehouse
(3, 2, 150),-- A4 Paper Ream in West Coast
(4, 3, 80), -- Industrial Bearing in South Hub
(4, 1, 18), -- Industrial Bearing in Main (Low Stock)
(5, 2, 40); -- Mechanical Keyboard in West Coast
