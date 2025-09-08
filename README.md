**Inventory and Warehouse Management System: SQL Backend**

This document outlines the SQL schema, queries, and automation logic for
a warehouse inventory management system.

**1. Database Schema**

The database consists of five main tables designed to track products,
suppliers, warehouses, and their stock levels.
![licensed-image](https://github.com/user-attachments/assets/5e4456d2-feb4-49ca-8fff-240400943776)


**Suppliers**

Stores supplier information.

- supplier_id: Primary Key

- supplier_name: Name of the supplier.

**Warehouses**

Stores information about each warehouse location.

- warehouse_id: Primary Key

- warehouse_name: Name of the warehouse (e.g., \"Main Warehouse\").

- location: Physical location of the warehouse.

**Products**

Contains details for each product.

- product_id: Primary Key

- product_name: Name of the product.

- reorder_level: The minimum quantity that triggers a reorder alert.

- supplier_id: Foreign key linking to the Suppliers table.

**Stock**

This is a junction table that tracks the inventory of each product
within each warehouse.

- product_id, warehouse_id: Composite Primary Key.

- quantity: The number of units of a specific product in a specific
  warehouse.

- last_updated: Timestamp that automatically updates when the record is
  changed.

**LowStockAlerts**

A log table to record every instance a product\'s stock drops below its
reorder level.

- alert_id: Primary Key.

- product_id, warehouse_id: Identifies the product and location of the
  alert.

- alert_message: A descriptive message about the alert.

- alert_date: Timestamp for when the alert was created.

**2. Inventory Queries**

These queries are used to monitor and manage inventory levels.

**Check All Stock Levels**

This query provides a complete overview of all products in every
warehouse, comparing the current quantity against the reorder level.

SELECT

p.product_name, w.warehouse_name, s.quantity, p.reorder_level

FROM Stock s

JOIN Products p ON s.product_id = p.product_id

JOIN Warehouses w ON s.warehouse_id = w.warehouse_id;

**Low Stock/Reorder Alerts**

This query identifies all products that have fallen below their
specified reorder_level and includes supplier contact information for
easy reordering.

SELECT

p.product_name, w.warehouse_name, s.quantity, p.reorder_level,
sup.supplier_name

FROM Stock s

JOIN Products p ON s.product_id = p.product_id

JOIN Warehouses w ON s.warehouse_id = w.warehouse_id

JOIN Suppliers sup ON p.supplier_id = sup.supplier_id

WHERE s.quantity \< p.reorder_level;

**3. Automation**

**Low Stock Trigger (After_Stock_Update_LowStockAlert)**

This trigger automatically runs after any UPDATE operation on the Stock
table. It checks if the new quantity is below the product\'s
reorder_level. If it is, a new entry is created in the LowStockAlerts
table, creating a historical log of low-stock events.

**Stock Transfer Procedure (TransferStock)**

This stored procedure provides a safe and controlled way to move stock
between two warehouses. It takes product ID, source warehouse,
destination warehouse, and quantity as parameters.

**Key Features:**

- **Transactional:** It uses a transaction to ensure that stock is
  either moved successfully or not at all. This prevents data
  inconsistencies, such as stock being removed from the source but not
  added to the destination.

- **Error Handling:** It checks for sufficient stock at the source
  before attempting the transfer. If stock is insufficient, it cancels
  the transaction and returns an error message.

**How to use it:**

\-- Transfer 10 units of product 1 from warehouse 1 to warehouse 2

CALL TransferStock(1, 1, 2, 10);
