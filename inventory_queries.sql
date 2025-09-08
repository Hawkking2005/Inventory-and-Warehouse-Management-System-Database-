-- Query 1: Check the current stock level for all products in all warehouses.
-- This query joins the Products, Stock, and Warehouses tables to provide a comprehensive view.
SELECT
    p.product_name,
    w.warehouse_name,
    s.quantity,
    p.reorder_level,
    s.last_updated
FROM
    Stock s
JOIN
    Products p ON s.product_id = p.product_id
JOIN
    Warehouses w ON s.warehouse_id = w.warehouse_id
ORDER BY
    p.product_name, w.warehouse_name;


-- Query 2: Generate a reorder alert for products with stock below their reorder level.
-- This is crucial for procurement to know which items to order.
SELECT
    p.product_name,
    w.warehouse_name,
    s.quantity,
    p.reorder_level,
    (p.reorder_level - s.quantity) AS reorder_amount,
    sup.supplier_name,
    sup.email AS supplier_email
FROM
    Stock s
JOIN
    Products p ON s.product_id = p.product_id
JOIN
    Warehouses w ON s.warehouse_id = w.warehouse_id
JOIN
    Suppliers sup ON p.supplier_id = sup.supplier_id
WHERE
    s.quantity < p.reorder_level
ORDER BY
    p.product_name;

-- Query 3: Get total stock quantity for a specific product across all warehouses.
-- This helps in understanding the overall availability of a product.
SELECT
    p.product_name,
    SUM(s.quantity) AS total_quantity
FROM
    Stock s
JOIN
    Products p ON s.product_id = p.product_id
WHERE
    p.product_name = 'Laptop Pro 15"'
GROUP BY
    p.product_name;
