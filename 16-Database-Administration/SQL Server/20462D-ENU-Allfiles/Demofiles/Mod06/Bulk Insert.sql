BULK INSERT Finance.dbo.Currency
FROM 'D:\Demofiles\Mod06\Currency.csv'
WITH 
      (
         FIELDTERMINATOR =',',
         ROWTERMINATOR ='\n'
      );
