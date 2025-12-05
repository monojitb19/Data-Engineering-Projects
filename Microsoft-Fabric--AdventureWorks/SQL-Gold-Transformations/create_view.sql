-- View for DimCalendar in the gold layer
CREATE OR ALTER VIEW gold.vw_DimCalendar
AS
SELECT *
FROM gold.DimCalendar;

-- View for DimCustomer in the gold layer
CREATE OR ALTER VIEW gold.vw_DimCustomer
AS
SELECT *
FROM gold.DimCustomer;


-- View for product categories
CREATE OR ALTER VIEW gold.vw_DimProductCategories
AS
SELECT *
FROM gold.DimProductCategories;


-- View for product subcategories
CREATE OR ALTER VIEW gold.vw_DimProductSubcategories
AS
SELECT *
FROM gold.DimProductSubcategories;


-- View for product dimension
CREATE OR ALTER VIEW gold.vw_DimProducts
AS
SELECT *
FROM gold.DimProducts;


-- View for returns dimension
CREATE OR ALTER VIEW gold.vw_DimReturns
AS
SELECT *
FROM gold.DimReturns;


-- View for territories dimension
CREATE OR ALTER VIEW gold.vw_DimTerritories
AS
SELECT *
FROM gold.DimTerritories;


-- View for FactSales table
CREATE OR ALTER VIEW gold.vw_FactSales
AS
SELECT *
FROM gold.FactSales;


--See all views in a schema
SELECT * FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'gold';
