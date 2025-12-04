-- Load FactSales into the gold layer
CREATE PROCEDURE gold.usp_LoadFactSales
AS
BEGIN
    -- Rebuild FactSales table
    DROP TABLE IF EXISTS gold.FactSales;

    CREATE TABLE gold.FactSales AS
    SELECT
        ProductKey,
        CustomerKey,
        TerritoryKey AS SalesTerritoryKey,   -- Rename for clarity
        OrderNumber,
        OrderLineItem,
        OrderQuantity,
        OrderDate,
        StockDate
    FROM MonoLH_Silver.dbo.factsales;
END;