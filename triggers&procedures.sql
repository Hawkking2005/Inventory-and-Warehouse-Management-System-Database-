-- Trigger: Low Stock Notification
-- This trigger automatically inserts a record into the LowStockAlerts table
-- whenever a product's quantity in the Stock table is updated to a value
-- below its reorder_level.
DELIMITER //

CREATE TRIGGER After_Stock_Update_LowStockAlert
AFTER UPDATE ON Stock
FOR EACH ROW
BEGIN
    DECLARE product_reorder_level INT;

    -- Get the reorder level for the product that was updated
    SELECT reorder_level INTO product_reorder_level
    FROM Products
    WHERE product_id = NEW.product_id;

    -- Check if the new quantity is below the reorder level
    IF NEW.quantity < product_reorder_level THEN
        -- Insert an alert into the LowStockAlerts table
        INSERT INTO LowStockAlerts (product_id, warehouse_id, alert_message)
        VALUES (NEW.product_id, NEW.warehouse_id, CONCAT('Stock for product ID ', NEW.product_id, ' is low (', NEW.quantity, ') at warehouse ID ', NEW.warehouse_id));
    END IF;
END;
//

DELIMITER ;


-- Stored Procedure: Transfer Stock between warehouses
-- This procedure handles the logic for moving a specified quantity of a product
-- from a source warehouse to a destination warehouse within a single transaction.
DELIMITER //

CREATE PROCEDURE TransferStock(
    IN p_product_id INT,
    IN p_source_warehouse_id INT,
    IN p_destination_warehouse_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE source_stock INT;

    -- Start a transaction to ensure atomicity
    START TRANSACTION;

    -- Check if the source warehouse has enough stock
    SELECT quantity INTO source_stock
    FROM Stock
    WHERE product_id = p_product_id AND warehouse_id = p_source_warehouse_id;

    IF source_stock >= p_quantity THEN
        -- Decrease stock from the source warehouse
        UPDATE Stock
        SET quantity = quantity - p_quantity
        WHERE product_id = p_product_id AND warehouse_id = p_source_warehouse_id;

        -- Increase stock in the destination warehouse
        -- Use INSERT ... ON DUPLICATE KEY UPDATE to handle cases where the product
        -- might not yet exist in the destination warehouse's stock.
        INSERT INTO Stock (product_id, warehouse_id, quantity)
        VALUES (p_product_id, p_destination_warehouse_id, p_quantity)
        ON DUPLICATE KEY UPDATE quantity = quantity + p_quantity;

        -- Commit the transaction if all operations are successful
        COMMIT;
    ELSE
        -- Rollback the transaction if there is not enough stock
        ROLLBACK;
        -- Signal an error state to the caller
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Insufficient stock in the source warehouse.';
    END IF;
END;
//

DELIMITER ;
