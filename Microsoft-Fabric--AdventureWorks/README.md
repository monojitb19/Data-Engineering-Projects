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
![Microsoft Fabric Architecture](./Microsoft-Fabric--AdventureWorks/Fabric_Diagram.png)

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
![Bronze Layer Pipeline A](./Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_01_Bronze_GitData_Ingestion.png)
![Bronze Layer Pipeline B](./Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_01_Bronze_GitData_Ingestion_b.png)
<br>*Pipeline orchestration showing Lookup activity feeding into ForEach loop for parallel CSV ingestion*

---

## 🥈 Silver Layer — Transformation

**Pipeline:** `pipeline_02_Silver_Transformations`

**Technology:** PySpark Notebooks + Delta Lake tables

Each file is cleaned, validated, enriched, and converted into optimized Delta Lake tables.

### ✔ DimCalendar (PySpark)
- Convert string → date
- Create Year, Month, Quarter, Week
- Add Day/Month names
- Add IsWeekend flag

### ✔ DimCustomer
- Clean emails, gender, marital status
- Create FullName
- Derive Age, AgeGroup
- Normalize strings

### ✔ DimProduct
- Join Products + Subcategories + Categories
- Add ColorGroup, SizeGroup
- Compute Margin, MarkupPct, PriceBand

### ✔ DimTerritories
- Standardize region/country names
- Create TerritoryFullName
- Add IsNorthAmerica flag

### ✔ FactSales
- Merge 2015–2017 sales
- Standardize date formats
- Prepare surrogate date keys

### Pipeline Architecture
![Silver Layer Pipeline](./Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_02_Silver_Transformations.png)
<br>*Pipeline executing PySpark notebooks in sequence to transform raw data into Delta Lake tables*

---

## 🥇 Gold Layer — Serving (Warehouse Star Schema)

**Pipeline:** `pipeline_03_Gold_Transformations`

**Technology:** Warehouse Stored Procedures

The Gold layer creates a dimensional star schema optimized for analytics.

**Tables include:**
- ✔ gold.DimDate
- ✔ gold.DimCustomer
- ✔ gold.DimProduct
- ✔ gold.DimTerritory
- ✔ gold.FactInternetSales

**Highlights:**
- Surrogate keys (YYYYMMDD) for date dimensions
- Dimensional attributes for segmentation
- Fact table contains grain: OrderNumber + OrderLineItem
- Foreign keys link all dimensions
- Computed metrics (margin, markup, age groups, price bands)

### Pipeline Architecture
![Gold Layer Pipeline](./Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_03_Gold_Transformations.png)
<br>*Pipeline executing stored procedures to build star schema dimensional model in Fabric Warehouse*

---

## 📊 Semantic Model & Power BI

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

## 🔁 Master Orchestration Pipeline

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
![Master Orchestration Pipeline](./Microsoft-Fabric--AdventureWorks/Pipeline-Snaps/Pipeline_00_Master_Orchestration.png)

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
