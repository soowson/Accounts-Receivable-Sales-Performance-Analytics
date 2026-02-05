BEGIN TRY
    BEGIN TRANSACTION;

    -- Using EXEC for a clean CREATE OR ALTER block
    EXEC('
    CREATE OR ALTER VIEW v_FinancialAnalysis AS
    SELECT 
        s.SalesOrderNumber,
        s.OrderDate,
        s.DueDate,
        s.ShipDate,
        p.EnglishProductName AS ProductName,
        pc.EnglishProductCategoryName AS Category,
        -- Handling NULLs in names for professional string concatenation
        ISNULL(c.FirstName, '''') + '' '' + ISNULL(c.LastName, '''') AS CustomerName,
        g.City,
        g.EnglishCountryRegionName AS Country,
        s.OrderQuantity,
        -- Securing monetary values against NULLs
        ISNULL(s.SalesAmount, 0) AS SalesAmount,
        ISNULL(s.TotalProductCost, 0) AS TotalProductCost,
        -- Calculating Gross Profit with data safety measures
        (ISNULL(s.SalesAmount, 0) - ISNULL(s.TotalProductCost, 0)) AS GrossProfit
    FROM FactInternetSales s
    -- Using LEFT JOIN to ensure no sales records are lost due to missing dimensions
    LEFT JOIN DimProduct p ON s.ProductKey = p.ProductKey
    LEFT JOIN DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
    LEFT JOIN DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
    LEFT JOIN DimCustomer c ON s.CustomerKey = c.CustomerKey
    LEFT JOIN DimGeography g ON c.GeographyKey = g.GeographyKey;
    ');

    COMMIT TRANSACTION;
    PRINT 'Success: v_FinancialAnalysis view has been created.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR (@ErrorMessage, 16, 1);
END CATCH;

select * from v_FinancialAnalysis