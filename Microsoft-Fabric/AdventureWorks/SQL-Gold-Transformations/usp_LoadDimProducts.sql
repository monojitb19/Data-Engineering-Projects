-- Load products into the gold layer with additional derived attributes
CREATE PROCEDURE gold.usp_LoadDimProducts
AS
BEGIN
    -- Recreate product dimension
    DROP TABLE IF EXISTS gold.DimProducts;
    CREATE TABLE gold.DimProducts AS
    SELECT
        ProductKey,
        ProductSubcategoryKey,
        ProductSKU,
        ProductSKUPrefix,
        ProductName,
        ModelName,
        ProductDescription,
        ProductColor,

        -- Standardized color grouping
        CASE
            WHEN ProductColor IN ('Red','Maroon') THEN 'Red'
            WHEN ProductColor IN ('Blue','Navy') THEN 'Blue'
            WHEN ProductColor = 'Black' THEN 'Black'
            WHEN ProductColor = 'White' THEN 'White'
            ELSE 'Other'
        END AS ColorGroup,

        ProductSize,

        -- Group sizes into buckets
        CASE
            WHEN ProductSize IN ('XS','S','28','30') THEN 'Small'
            WHEN ProductSize IN ('M','32','34') THEN 'Medium'
            WHEN ProductSize IN ('L','36','38') THEN 'Large'
            WHEN ProductSize IN ('XL','XXL','40','42') THEN 'Extra Large'
            ELSE 'Unknown'
        END AS SizeGroup,

        ProductStyle,
        ProductCost,
        ProductPrice,

        -- Margin amount
        (ProductPrice - ProductCost) AS Margin,

        -- Markup percentage
        CASE 
            WHEN ProductCost = 0 THEN NULL
            ELSE (ProductPrice - ProductCost) / ProductCost
        END AS MarkupPct,

        -- Price classification
        CASE
            WHEN ProductPrice < 50 THEN 'Budget'
            WHEN ProductPrice BETWEEN 50 AND 149.99 THEN 'Mid-Range'
            WHEN ProductPrice BETWEEN 150 AND 499.99 THEN 'High'
            ELSE 'Premium'
        END AS PriceBand

    FROM MonoLH_Silver.dbo.dimproducts;
END;