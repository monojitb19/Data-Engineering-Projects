-- Load product categories and subcategories into the gold layer
CREATE PROCEDURE gold.usp_LoadDimProCat_Subcat
AS
BEGIN
    -- Refresh Product Categories
    DROP TABLE IF EXISTS gold.DimProductCategories;
    CREATE TABLE gold.DimProductCategories AS
    SELECT
        ProductCategoryKey,
        CategoryName
    FROM MonoLH_Silver.dbo.dimproductcategories;

    -- Refresh Product Subcategories
    DROP TABLE IF EXISTS gold.DimProductSubcategories;
    CREATE TABLE gold.DimProductSubcategories AS
    SELECT
        ProductSubcategoryKey,
        SubcategoryName,
        ProductCategoryKey
    FROM MonoLH_Silver.dbo.dimproductsubcategories;
END;