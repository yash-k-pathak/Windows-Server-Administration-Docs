INSERT INTO Finance.dbo.SalestaxRate
SELECT * FROM OPENROWSET (BULK 'D:\Demofiles\Mod06\SalesTaxRate.csv’,
FORMATFILE = 'D:\Demofiles\Mod06\TaxRateFmt.xml') AS rows;
