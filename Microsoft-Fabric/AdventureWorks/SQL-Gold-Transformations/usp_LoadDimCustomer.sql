-- Procedure to refresh (drop + recreate) the DimCustomer table in the gold layer
CREATE PROCEDURE gold.usp_LoadDimCustomer
AS
BEGIN
    -- Drop existing table before reload
    DROP TABLE IF EXISTS gold.DimCustomer;

    -- Rebuild DimCustomer using Silver-layer source data
    CREATE TABLE gold.DimCustomer AS
    SELECT
        CustomerKey,
        Prefix,
        FullName,
        Gender,

        -- Convert gender codes to readable values
        CASE 
            WHEN Gender = 'M' THEN 'Male'
            WHEN Gender = 'F' THEN 'Female'
            ELSE 'Unknown'
        END AS GenderDescription,

        MaritalStatus,

        -- Standardize marital status descriptions
        CASE 
            WHEN MaritalStatus = 'S' THEN 'Single'
            WHEN MaritalStatus = 'M' THEN 'Married'
            WHEN MaritalStatus = 'D' THEN 'Divorced'
            ELSE 'Unknown'
        END AS MaritalStatusDescription,

        BirthDate,
        DATEDIFF(year, BirthDate, GETDATE()) AS Age,   -- Calculate age

        -- Bucket customers into age groups
        CASE 
            WHEN DATEDIFF(year, BirthDate, GETDATE()) < 25 THEN 'Under 25'
            WHEN DATEDIFF(year, BirthDate, GETDATE()) BETWEEN 25 AND 34 THEN '25-34'
            WHEN DATEDIFF(year, BirthDate, GETDATE()) BETWEEN 35 AND 44 THEN '35-44'
            WHEN DATEDIFF(year, BirthDate, GETDATE()) BETWEEN 45 AND 54 THEN '45-54'
            WHEN DATEDIFF(year, BirthDate, GETDATE()) >= 55 THEN '55+'
            ELSE 'Unknown'
        END AS AgeGroup,

        EmailAddress,
        AnnualIncome,

        -- Income banding for segmentation
        CASE
            WHEN AnnualIncome < 25000 THEN '<25K'
            WHEN AnnualIncome BETWEEN 25000 AND 50000 THEN '25K-50K'
            WHEN AnnualIncome BETWEEN 50001 AND 75000 THEN '50K-75K'
            WHEN AnnualIncome BETWEEN 75001 AND 100000 THEN '75K-100K'
            ELSE '100K+'
        END AS IncomeBand,

        TotalChildren,
        CASE WHEN TotalChildren > 0 THEN 1 ELSE 0 END AS HasChildren,  -- Flag for children

        EducationLevel,
        Occupation,

        HomeOwner,

        -- Normalize homeowner flag
        CASE 
            WHEN HomeOwner IN ('Y','Yes','1','True','true') THEN 1 
            ELSE 0 
        END AS IsHomeOwner,

        -- Simple customer segmentation
        CASE
            WHEN AnnualIncome >= 75000 
                 AND EducationLevel IN ('Bachelors','Graduate Degree') THEN 'High Value'
            WHEN AnnualIncome BETWEEN 50000 AND 74999 THEN 'Mid Value'
            WHEN AnnualIncome < 50000 AND TotalChildren > 0 THEN 'Family'
            ELSE 'Standard'
        END AS CustomerSegment

    FROM MonoLH_Silver.dbo.dimcustomer;
END;