USE AdventureWorks;
GO

SELECT	YEAR(o.OrderDate) AS CalendarYear,
		s.Name AS SubCategory,
		SUM (d.OrderQty) ItemsSold,
		SUM(d.LineTotal) As Revenue
FROM Sales.SalesOrderHeader o
JOIN Sales.SalesOrderDetail d ON d.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID
JOIN Production.ProductSubcategory s ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN Production.ProductCategory pc ON s.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Bikes'
GROUP BY YEAR(o.OrderDate), s.Name
ORDER BY YEAR(o.OrderDate), s.Name;
GO 20

