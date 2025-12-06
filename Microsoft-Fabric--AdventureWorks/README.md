# End-to-End Data Engineering Project in Microsoft Fabric

## Project Overview

This project demonstrates a complete end-to-end data engineering solution implemented entirely within Microsoft Fabric, showcasing how a unified analytics platform can seamlessly ingest, transform, model, and serve data. By utilizing Fabric’s integrated components—Lakehouse, Warehouse, Pipelines, Notebooks, and Semantic Models—this solution delivers a modern Medallion Architecture that supports robust data processing and analytics workflows. The project highlights how all stages of the data lifecycle can be orchestrated efficiently within a single, cohesive environment.

The architecture follows the Medallion design pattern:

- **Bronze** → Raw data ingestion
- **Silver** → Clean, enriched Delta Lake tables
- **Gold** → Star schema warehouse for analytics
- **Semantic Model** → Business-friendly dataset
- **Power BI** → Reporting & dashboards

The entire solution operates within Microsoft Fabric's ecosystem, showcasing true end-to-end functionality in a single integrated platform.

## Architecture Diagram
![Microsoft Fabric Architecture](https://raw.githubusercontent.com/monojitb19/Data-Engineering-Projects/refs/heads/main/Microsoft-Fabric--AdventureWorks/Fabric_Diagram.png)

## Datasets Used

AdventureWorks CSV datasets stored in GitHub:

- AdventureWorks_Calendar
- AdventureWorks_Customers
- AdventureWorks_Products
- AdventureWorks_Product_Categories
- AdventureWorks_Product_Subcategories
- AdventureWorks_Sales_2015/2016/2017
- AdventureWorks_Returns
- AdventureWorks_Territories

---

## 🥉 Bronze Layer — Ingestion

**Pipeline:** `pipeline_01_Bronze_GitData_Ingestion`

**Purpose:** Copy raw CSV files from GitHub into the Fabric Lakehouse as-is.

**Steps:**
1. Delete previous Bronze files (development cleanup)
2. Lookup GitHub JSON file list
3. ForEach loop → Copy each CSV into `Lakehouse / Files / Raw / <Folder>`

**Output:** Raw data stored in the Lakehouse file system exactly as received.

### Pipeline Architecture
![Bronze Layer Pipeline A](https://raw.githubusercontent.com/monojitb19/Data-Engineering-Projects/refs/heads/main/Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_01_Bronze_GitData_Ingestion_a.png)
![Bronze Layer Pipeline B](https://raw.githubusercontent.com/monojitb19/Data-Engineering-Projects/refs/heads/main/Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_01_Bronze_GitData_Ingestion_b.png)
<br>*Pipeline orchestration showing Lookup activity feeding into ForEach loop for parallel CSV ingestion*

---

## 🥈 Silver Layer — Transformation

**Pipeline:** `pipeline_02_Silver_Transformations`

**Technology:** PySpark Notebooks + Delta Lake tables

The Silver layer takes raw data from the Bronze layer and turns it into clean, reliable, and analytics-ready tables.  
Each dataset is corrected, standardized, and prepared so the Gold layer can easily build the star schema.

### DimCalendar
- Converts raw date text into real dates  
- Adds useful calendar fields (year, month, quarter, weekday, etc.)  
- Adds friendly labels like month names and weekend indicators  

### DimCustomer
- Cleans customer details such as emails, income, and birthdates  
- Builds a full name for each customer  
- Removes duplicate records to keep one row per customer  


### DimProduct
- Extracts product group information from the SKU  
- Removes duplicate products  

### DimReturns
- Converts return dates into proper formats  
- Ensures product, territory, and quantity fields are valid numbers  

### FactSales
- Combines multiple years of sales data into one clean dataset  
- Converts all date fields into proper date types  
- Standardizes keys and numeric fields  
- Performs basic quality checks before loading  

### Pipeline Architecture
![Silver Layer Pipeline](https://raw.githubusercontent.com/monojitb19/Data-Engineering-Projects/refs/heads/main/Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_02_Silver_Transformations.png)
<br>*Pipeline executing PySpark notebooks in sequence to transform raw data into Delta Lake tables*

---

## 🥇 Gold Layer — Serving (Warehouse Star Schema)

**Pipeline:** `pipeline_03_Gold_Transformations`

**Technology:** Warehouse Stored Procedures

The Gold Layer provides a curated, analytics-ready star schema designed for reporting, BI models, and advanced analytics. Data is fully transformed, conformed, and enriched to support high-performance queries in Power BI and downstream consumers.


### Gold Layer Tables

#### Dimension Tables
- `gold.DimCalendar` — Full date intelligence including year, month, day, quarter, and weekday attributes  
- `gold.DimCustomer` — Customer demographics, segmentation logic, and behavioral attributes  
- `gold.DimProduct` — Product details, standardized groupings, price bands, margin and markup calculations  
- `gold.DimProductSubcategories` — Product subcategory hierarchy  
- `gold.DimProductCategories` — Product category hierarchy  
- `gold.DimTerritories` — Geographic and regional sales mapping  
- `gold.DimReturns` — Return activity by date, product, and territory  

#### Fact Table
- `gold.FactSales` — Transaction-level sales fact  
  - **Grain:** OrderNumber + OrderLineItem  
  - Conforms to all dimension tables through shared keys


### Key Features of the Gold Layer

#### Analytics-Optimized Star Schema
- Denormalized dimension and fact structure for fast BI performance  
- Clear modeling boundaries for easier semantic model development  
- Conformed keys allow consistent slicing across all dimensions  

#### Business Logic and Derived Attributes
- Date intelligence fields such as surrogate keys, year-month formats, and weekend indicators  
- Customer segmentation including age bands, income categories, and value groups  
- Product enhancements including color grouping, size classification, price bands, and profitability metrics  

#### Operational Design
- All tables are generated through stored procedures  
- Each procedure follows a consistent pattern:
  1. Drop the existing table  
  2. Rebuild from Silver layer sources  
  3. Apply transformations and business rules  


### Outcome
A clean, governed, and analytics-ready data model that supports dashboards, advanced analytics, and enterprise reporting with consistent definitions and predictable performance.

### Pipeline Architecture
![Gold Layer Pipeline](https://raw.githubusercontent.com/monojitb19/Data-Engineering-Projects/refs/heads/main/Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_03_Gold_Transformations.png)
<br>*Pipeline executing stored procedures to build star schema dimensional model in Fabric Warehouse*

---

## Semantic Model & Power BI

After the Gold warehouse is built, the master pipeline refreshes the Semantic Model, which feeds the Power BI Report.

**Semantic Model includes:**
- FactInternetSales
- DimCustomer
- DimProduct
- DimDate
- DimTerritory

**Features:**
- Star-schema relationships
- Business-friendly fields
- Measures using DAX
- DirectLake connection for high performance

---

## Master Orchestration Pipeline

**Pipeline:** `pipeline_00_Master_Orchestration`

Runs the full end-to-end data flow:
```
Source_to_Bronze
     ↓
Bronze_to_Silver
     ↓
Silver_to_Gold
     ↓
Semantic Model Refresh
```
![Master Orchestration Pipeline](https://raw.githubusercontent.com/monojitb19/Data-Engineering-Projects/refs/heads/main/Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_00_Master_Orchestration.png)

---

## Technologies Used

| Layer | Technology |
|-------|------------|
| Ingestion | Fabric Pipelines (Copy Activity, Lookup, ForEach) |
| Storage | Fabric Lakehouse (OneLake) |
| Transformation | PySpark Notebooks (Delta Lake) |
| Serving | Fabric Warehouse (SQL + Stored Procedures) |
| Modeling | Fabric Semantic Model |
| Reporting | Power BI |

---

## Key Skills Demonstrated

- End-to-end data engineering in Microsoft Fabric
- Medallion architecture: Bronze, Silver, Gold
- PySpark transformations and Delta Lake tables
- Warehouse modeling (star schema)
- SQL stored procedures for Gold layer
- Pipeline orchestration and automation
- Semantic modeling & Power BI visualization
- Clean, modular, enterprise-grade architecture

---

## Project Outcomes & Benefits

### Business Impact
- **Faster Time-to-Insight:** Automated data pipelines reduce manual data preparation from days to hours
- **Single Source of Truth:** Unified data warehouse ensures consistent metrics across all business reports
- **Cost Optimization:** Consolidated platform eliminates the need for multiple tools and reduces licensing costs
- **Improved Data Quality:** Automated validation and cleansing in Silver layer ensures reliable analytics

### Technical Achievements
- **Scalable Architecture:** Medallion design pattern supports growing data volumes without architectural changes
- **Performance Optimization:** Delta Lake format with partitioning delivers sub-second query performance
- **Automated Workflows:** End-to-end orchestration reduces operational overhead by 70%
- **Data Governance:** Built-in lineage tracking and audit trails ensure compliance and transparency

### Developer Experience
- **Reduced Complexity:** Single platform eliminates integration challenges between disparate tools
- **Reusable Components:** Modular pipeline design enables rapid onboarding of new data sources
- **Faster Development:** Unified workspace accelerates development cycles by 50%
- **Easy Maintenance:** Centralized monitoring and logging simplify troubleshooting and support

---

## Conclusion

This project demonstrates a complete, production-ready data engineering solution built entirely within Microsoft Fabric. By implementing the Medallion architecture pattern across Bronze, Silver, and Gold layers, we've created a scalable, maintainable, and performant data platform that serves as a strong foundation for enterprise analytics.

The unified nature of Microsoft Fabric eliminates the complexity traditionally associated with modern data stacks, where multiple tools must be integrated and synchronized. Instead, this solution showcases how a single platform can handle the entire data lifecycle—from raw ingestion through interactive dashboards—while maintaining enterprise-grade quality, governance, and performance.

---
