-- Load returns dimension into the gold layer
CREATE PROCEDURE gold.usp_LoadDimReturns
AS
BEGIN
    -- Rebuild DimReturns table
    DROP TABLE IF EXISTS gold.DimReturns;

    CREATE TABLE gold.DimReturns AS
    SELECT
        ReturnDate,
        TerritoryKey,
        ProductKey,
        ReturnQuantity
    FROM MonoLH_Silver.dbo.dimreturns;
END;