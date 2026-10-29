                  ADVENTURE WORKS PROJECT SQL
				---------------------------------
-- Validation and troubleshooting
-------------------------------------------------------------------
SHOW DATABASES;

-------------------------------------------------------------------
-- - Table definitions and schema changes
-------------------------------------------------------------------
-- Creating DimProductCategory
-------------------------------------------------------------------
CREATE TABLE DimProductCategory (
    ProductCategoryKey INT PRIMARY KEY,
    ProductCategoryAlternateKey INT,
    EnglishProductCategoryName VARCHAR(100),
    SpanishProductCategoryName VARCHAR(100),
    FrenchProductCategoryName VARCHAR(100)
);

-------------------------------------------------------------------
-- - Database setup
-------------------------------------------------------------------


-------------------------------------------------------------------
-- Creating database AdventureWorks_Project
-------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS AdventureWorks_Project;

-------------------------------------------------------------------
-- - Table definitions and schema changes
-------------------------------------------------------------------
CREATE TABLE DimProductCategory (
    ProductCategoryKey INT,
    ProductCategoryAlternateKey INT,
    EnglishProductCategoryName VARCHAR(100),
    SpanishProductCategoryName VARCHAR(100),
    FrenchProductCategoryName VARCHAR(100)
);

-------------------------------------------------------------------
-- Creating DimProductSubCategory
-------------------------------------------------------------------
CREATE TABLE DimProductSubCategory (
    ProductSubcategoryKey INT,
    ProductSubcategoryAlternateKey INT,
    EnglishProductSubcategoryName VARCHAR(100),
    ProductCategoryKey INT
);

-------------------------------------------------------------------
-- Creating DimProduct
-------------------------------------------------------------------
CREATE TABLE DimProduct (
    ProductKey INT,
    EnglishProductName VARCHAR(200),
    ProductSubcategoryKey INT,
    UnitPrice DECIMAL(18,2),
    ProductStandardCost DECIMAL(18,2)
);

-------------------------------------------------------------------
-- Creating DimCustomer
-------------------------------------------------------------------
CREATE TABLE DimCustomer (
    CustomerKey INT,
    FirstName VARCHAR(100),
    MiddleName VARCHAR(100),
    LastName VARCHAR(100)
);

-------------------------------------------------------------------
-- Creating DimSalesTerritory
-------------------------------------------------------------------
CREATE TABLE DimSalesTerritory (
    SalesTerritoryKey INT,
    SalesTerritoryRegion VARCHAR(100)
);

-------------------------------------------------------------------
-- Creating DimDate
-------------------------------------------------------------------
CREATE TABLE DimDate (
    DateKey INT,
    FullDate DATE,
    Year INT,
    MonthNo INT,
    MonthName VARCHAR(20),
    QuarterName VARCHAR(10)
);

-------------------------------------------------------------------
-- Creating FactInternetSales
-------------------------------------------------------------------
CREATE TABLE FactInternetSales (
    ProductKey INT,
    OrderDateKey INT,
    CustomerKey INT,
    SalesTerritoryKey INT,
    SalesOrderNumber VARCHAR(50),
    SalesOrderLineNumber INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(18,2),
    ExtendedAmount DECIMAL(18,2),
    UnitPriceDiscountPct DECIMAL(18,4),
    DiscountAmount DECIMAL(18,2),
    ProductStandardCost DECIMAL(18,2),
    TotalProductCost DECIMAL(18,2),
    SalesAmount DECIMAL(18,2),
    OrderDate DATE,
    DueDate DATE,
    ShipDate DATE
);

-------------------------------------------------------------------
-- Creating FactInternetSalesNew
-------------------------------------------------------------------
CREATE TABLE FactInternetSalesNew (
    ProductKey INT,
    OrderDateKey INT,
    CustomerKey INT,
    SalesTerritoryKey INT,
    SalesOrderNumber VARCHAR(50),
    SalesOrderLineNumber INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(18,2),
    ExtendedAmount DECIMAL(18,2),
    UnitPriceDiscountPct DECIMAL(18,4),
    DiscountAmount DECIMAL(18,2),
    ProductStandardCost DECIMAL(18,2),
    TotalProductCost DECIMAL(18,2),
    SalesAmount DECIMAL(18,2),
    OrderDate DATE,
    DueDate DATE,
    ShipDate DATE
);

-------------------------------------------------------------------
-- - Validation and troubleshooting
-------------------------------------------------------------------
DESCRIBE DimProduct;

-------------------------------------------------------------------
-- - Table definitions and schema changes
-------------------------------------------------------------------

-------------------------------------------------------------------
-- Analysis and reporting queries
-------------------------------------------------------------------
SELECT
    DATABASE();

-------------------------------------------------------------------
-- - Table definitions and schema changes
-------------------------------------------------------------------


-------------------------------------------------------------------
-- - Analysis and reporting queries
-------------------------------------------------------------------
-- Selecting from DimProductCategory
-------------------------------------------------------------------
SELECT
    *
FROM DimProductCategory;

-------------------------------------------------------------------
-- - Table definitions and schema changes
-------------------------------------------------------------------
-- Dropping FactInternetSales
-------------------------------------------------------------------
DROP TABLE IF EXISTS FactInternetSales;

-------------------------------------------------------------------
-- - Analysis and reporting queries
-------------------------------------------------------------------
SELECT
    COUNT(*) AS TotalRows
FROM FactInternetSales;

-------------------------------------------------------------------
-- Selecting from FactInternetSalesNew
-------------------------------------------------------------------
SELECT
    COUNT(*) AS TotalRows
FROM FactInternetSalesNew;

-------------------------------------------------------------------
-- Selecting from factinternetsalesnew
-------------------------------------------------------------------
SELECT
    COUNT(*) AS Rows2
FROM factinternetsalesnew;

-------------------------------------------------------------------
-- - Table definitions and schema changes
-------------------------------------------------------------------
-- Dropping `adventureworks_project`
-------------------------------------------------------------------
DROP TABLE `adventureworks_project`.`factinternetsalesnew`;

-------------------------------------------------------------------
-- - Analysis and reporting queries
-------------------------------------------------------------------
SELECT
    COUNT(*) AS Rows1
FROM fact_internet_sales_new;

-------------------------------------------------------------------
-- - Table definitions and schema changes
-------------------------------------------------------------------
-- Creating FactInternetSalesUnion
-------------------------------------------------------------------
CREATE TABLE FactInternetSalesUnion AS SELECT * FROM FactInternetSales UNION ALL SELECT * FROM FactInternetSalesNew;

-- QUESTION 1: Lookup ProductName from Product sheet to Sales sheet
-------------------------------------------------------------------

SELECT
    F.ProductKey,
    P.EnglishProductName AS ProductName,
    F.OrderQuantity,
    F.UnitPrice
FROM FactInternetSalesUnion AS F
JOIN DimProduct AS P
    ON F.ProductKey = P.ProductKey
LIMIT 20;

-------------------------------------------------------------------
-- QUESTION 2A: Lookup CustomerFullName from Customer to Sales
-------------------------------------------------------------------

SELECT
    F.CustomerKey,
    CONCAT_WS(' ', C.FirstName, C.MiddleName, C.LastName) AS CustomerFullName,
    F.SalesAmount
FROM FactInternetSalesUnion AS F
JOIN DimCustomer AS C
    ON F.CustomerKey = C.CustomerKey
LIMIT 20;


-------------------------------------------------------------------
-- QUESTION 2B: Lookup Product Name and Unit Price from Product
-- Note: The source column is named `Unit price` (with a space).
-------------------------------------------------------------------

SELECT
    F.ProductKey,
    P.EnglishProductName AS ProductName,
    P.`Unit price` AS ProductUnitPrice
FROM FactInternetSalesUnion AS F
JOIN DimProduct AS P
    ON F.ProductKey = P.ProductKey
LIMIT 20;


--------------------------------------------------------------------------------
-- QUESTION 3: Create date fields and analyze sales by year, month, and quarter
-- OrderDateKey is assumed to be an integer in YYYYMMDD format.
-- This query converts it for display without changing table data.
-----------------------------------------------------------------------------------

SELECT
    OrderDateKey,
    STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate
FROM FactInternetSalesUnion
LIMIT 20;


-- Sales by year
SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS SalesYear,
    SUM(SalesAmount) AS TotalSales
FROM FactInternetSalesUnion
GROUP BY YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
ORDER BY SalesYear;


-- Sales by month
SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS SalesYear,
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthName,
    SUM(SalesAmount) AS TotalSales
FROM FactInternetSalesUnion
GROUP BY
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
ORDER BY SalesYear, MonthNo;


-- Sales by quarter (includes quarter name in GROUP BY for ONLY_FULL_GROUP_BY compatibility)
SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS SalesYear,
    QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS QuarterNo,
    CONCAT('Q', QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))) AS QuarterName,
    SUM(SalesAmount) AS TotalSales
FROM FactInternetSalesUnion
GROUP BY
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    CONCAT('Q', QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')))
ORDER BY SalesYear, QuarterNo;


-------------------------------------------------------------------
-- QUESTION 4: Calculate Sales Amount
-------------------------------------------------------------------

SELECT
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS CalculatedSalesAmount
FROM FactInternetSalesUnion;


-------------------------------------------------------------------
-- QUESTION 5: Calculate Production Cost
-------------------------------------------------------------------

SELECT
    SUM(ProductStandardCost * OrderQuantity) AS ProductionCost
FROM FactInternetSalesUnion;

-------------------------------------------------------------------
-- QUESTION 6: Calculate Profit
-------------------------------------------------------------------

SELECT
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS TotalSales,
    SUM(ProductStandardCost * OrderQuantity) AS ProductionCost,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct))
        - SUM(ProductStandardCost * OrderQuantity) AS Profit
FROM FactInternetSalesUnion;


----------------------------------------------------------------------------
-- QUESTION 7: Pivot-table-style output for Month and Sales, Year as filter
----------------------------------------------------------------------------

SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS SalesYear,
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthName,
    SUM(SalesAmount) AS TotalSales
FROM FactInternetSalesUnion
GROUP BY
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
ORDER BY SalesYear, MonthNo;


----------------------------------------------------------------------------
-- QUESTION 8: Bar chart - Year-wise Sales
----------------------------------------------------------------------------

SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS SalesYear,
    SUM(SalesAmount) AS TotalSales
FROM FactInternetSalesUnion
GROUP BY YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
ORDER BY SalesYear;


----------------------------------------------------------------------------
-- QUESTION 9: Line chart - Month-wise Sales
----------------------------------------------------------------------------

SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS SalesYear,
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthName,
    SUM(SalesAmount) AS TotalSales
FROM FactInternetSalesUnion
GROUP BY
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
ORDER BY SalesYear, MonthNo;


----------------------------------------------------------------------------
-- QUESTION 10: Pie chart - Quarter-wise Sales
-- Grouping by QuarterName avoids Error 1055 with ONLY_FULL_GROUP_BY enabled.
----------------------------------------------------------------------------

SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS SalesYear,
    QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS QuarterNo,
    CONCAT('Q', QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))) AS QuarterName,
    SUM(SalesAmount) AS TotalSales
FROM FactInternetSalesUnion
GROUP BY
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    CONCAT('Q', QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')))
ORDER BY SalesYear, QuarterNo;


----------------------------------------------------------------------------
-- QUESTION 11: Combination chart - Sales Amount and Production Cost
-- One result set is useful for building a combination chart.
----------------------------------------------------------------------------

SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS SalesYear,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS CalculatedSalesAmount,
    SUM(ProductStandardCost * OrderQuantity) AS ProductionCost
FROM FactInternetSalesUnion
GROUP BY YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
ORDER BY SalesYear;


----------------------------------------------------------------------------
-- QUESTION 12A: Performance analysis by Product
----------------------------------------------------------------------------

SELECT
    P.ProductKey,
    P.EnglishProductName AS ProductName,
    SUM(F.UnitPrice * F.OrderQuantity * (1 - F.UnitPriceDiscountPct)) AS SalesAmount,
    SUM(F.ProductStandardCost * F.OrderQuantity) AS ProductionCost,
    SUM(F.UnitPrice * F.OrderQuantity * (1 - F.UnitPriceDiscountPct))
        - SUM(F.ProductStandardCost * F.OrderQuantity) AS Profit,
    SUM(F.OrderQuantity) AS TotalQuantity
FROM FactInternetSalesUnion AS F
JOIN DimProduct AS P
    ON F.ProductKey = P.ProductKey
GROUP BY P.ProductKey, P.EnglishProductName
ORDER BY SalesAmount DESC;


----------------------------------------------------------------------------
-- QUESTION 12B: Performance analysis by Customer
----------------------------------------------------------------------------

SELECT
    C.CustomerKey,
    CONCAT_WS(' ', C.FirstName, C.MiddleName, C.LastName) AS CustomerFullName,
    SUM(F.SalesAmount) AS TotalSales
FROM FactInternetSalesUnion AS F
JOIN DimCustomer AS C
    ON F.CustomerKey = C.CustomerKey
GROUP BY C.CustomerKey, C.FirstName, C.MiddleName, C.LastName
ORDER BY TotalSales DESC;


----------------------------------------------------------------------------
-- QUESTION 12C: Performance analysis by Region
----------------------------------------------------------------------------

SELECT
    T.SalesTerritoryRegion AS Region,
    SUM(F.SalesAmount) AS TotalSales
FROM FactInternetSalesUnion AS F
JOIN DimSalesTerritory AS T
    ON F.SalesTerritoryKey = T.SalesTerritoryKey
GROUP BY T.SalesTerritoryRegion
ORDER BY TotalSales DESC;


----------------------------------------------------------------------------
-- QUESTION 12D: Performance analysis by Product Category
----------------------------------------------------------------------------

SELECT
    PC.EnglishProductCategoryName AS ProductCategory,
    SUM(F.SalesAmount) AS TotalSales
FROM FactInternetSalesUnion AS F
JOIN DimProduct AS P
    ON F.ProductKey = P.ProductKey
JOIN DimProductSubCategory AS SC
    ON P.ProductSubcategoryKey = SC.ProductSubcategoryKey
JOIN DimProductCategory AS PC
    ON SC.ProductCategoryKey = PC.ProductCategoryKey
GROUP BY PC.EnglishProductCategoryName
ORDER BY TotalSales DESC;

-------------------------------------------------------------------
Lookup ProductName from Product sheet to Sales sheet
-------------------------------------------------------------------
SELECT *
FROM FactInternetSalesUnion;

SELECT
    -- Fact table columns
    F.*,

    -- Product information
    P.EnglishProductName AS ProductName,

    -- Customer information
    CONCAT_WS(' ', C.FirstName, C.MiddleName, C.LastName) AS CustomerFullName,

    -- Territory information
    T.SalesTerritoryRegion AS Region,

    -- Product Subcategory information
    SC.EnglishProductSubcategoryName AS ProductSubcategory,

    -- Product Category information
    PC.EnglishProductCategoryName AS ProductCategory,

    -- Date calculations
    YEAR(F.OrderDate) AS SalesYear,
    MONTH(F.OrderDate) AS MonthNo,
    MONTHNAME(F.OrderDate) AS MonthName,
    CONCAT('Q', QUARTER(F.OrderDate)) AS QuarterName,

    -- Sales
    (F.UnitPrice * F.OrderQuantity *
     (1 - F.UnitPriceDiscountPct)) AS CalculatedSales,

    -- Production Cost
    (F.ProductStandardCost * F.OrderQuantity) AS ProductionCost,

    -- Profit
    (
        (F.UnitPrice * F.OrderQuantity *
         (1 - F.UnitPriceDiscountPct))
        -
        (F.ProductStandardCost * F.OrderQuantity)
    ) AS Profit,

    -- Profit Margin
    ROUND(
        (
            (
                (F.UnitPrice * F.OrderQuantity *
                 (1 - F.UnitPriceDiscountPct))
                -
                (F.ProductStandardCost * F.OrderQuantity)
            )
            /
            NULLIF(
                (F.UnitPrice * F.OrderQuantity *
                 (1 - F.UnitPriceDiscountPct)),
                0
            )
        ) * 100,
        2
    ) AS ProfitMargin

FROM FactInternetSalesUnion F

-- LEFT JOIN CHAIN: Fact → Product
LEFT JOIN DimProduct P
    ON F.ProductKey = P.ProductKey

-- LEFT JOIN CHAIN: Product → Subcategory
LEFT JOIN DimProductSubCategory SC
    ON P.ProductSubcategoryKey = SC.ProductSubcategoryKey

-- LEFT JOIN CHAIN: Subcategory → Category
LEFT JOIN DimProductCategory PC
    ON SC.ProductCategoryKey = PC.ProductCategoryKey

-- Customer
LEFT JOIN DimCustomer C
    ON F.CustomerKey = C.CustomerKey

-- Territory
LEFT JOIN DimSalesTerritory T
    ON F.SalesTerritoryKey = T.SalesTerritoryKey;

