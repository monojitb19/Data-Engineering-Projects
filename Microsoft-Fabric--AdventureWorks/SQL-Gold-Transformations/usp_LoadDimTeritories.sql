-- Load teritories dimension into the gold layer
CREATE PROCEDURE gold.usp_LoadDimTeritories
AS
BEGIN
    -- Rebuild DimTeritories table
    DROP TABLE IF EXISTS gold.DimTerritories;

    -- Create DimTerritories from Silver source
    CREATE TABLE gold.DimTerritories AS
    SELECT
        SalesTerritoryKey,
        Region,
        Country,
        Continent
    FROM MonoLH_Silver.dbo.dimterritories;
END;