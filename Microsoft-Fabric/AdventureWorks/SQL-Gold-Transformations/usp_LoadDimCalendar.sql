-- Procedure to refresh (drop and recreate) the DimCalendar table in the gold layer
CREATE PROCEDURE gold.usp_LoadDimCalendar
AS
BEGIN
    -- Remove the existing DimCalendar table to ensure a full reload
    DROP TABLE IF EXISTS gold.DimCalendar;
    
    -- Recreate DimCalendar using the source data from Silver
    CREATE TABLE gold.DimCalendar AS
    SELECT
        Date,
        Year,
        Month,
        Day,
        Quarter,
        Month_Name,
        Month_Short,
        Day_Name,
        Day_Short,
        Month_Year,
        Week_of_Year,
        Day_of_Week,
        Year_Month,
        Is_Weekend
    FROM MonoLH_Silver.dbo.dimcalendar;
END;