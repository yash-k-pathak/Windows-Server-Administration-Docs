USE master
GO

-- Create Finance
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'Finance')
	DROP DATABASE Finance;
GO

CREATE DATABASE Finance ON  PRIMARY 
(  NAME = N'Finance', 
   FILENAME = N'$(SUBDIR)SetupFiles\Finance.mdf' , 
   SIZE = 10240KB, 
   FILEGROWTH = 1024KB 
)
 LOG ON 
( NAME = N'Finance_log', 
  FILENAME = N'$(SUBDIR)SetupFiles\Finance_log.ldf' , 
  SIZE = 5120KB, 
  FILEGROWTH = 10%
);
GO

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = 'Finance';
GO

-- Set the full recovery model
ALTER DATABASE Finance SET RECOVERY SIMPLE;
GO

--  Create a table in the database
CREATE TABLE [Finance].[dbo].[Currency](
	[CurrencyCode] [nchar](3) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](50) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Currency_ModifiedDate] DEFAULT (getdate()) 
	);
GO


CREATE TABLE [Finance].[dbo].[SalesTaxRate](
	[SalesTaxRateID] [int] NOT NULL PRIMARY KEY,
	[StateProvinceID] [int] NOT NULL,
	[TaxType] [tinyint] NOT NULL,
	[TaxRate] [smallmoney] NOT NULL CONSTRAINT [DF_SalesTaxRate_TaxRate]  DEFAULT ((0.00)),
	[Name] [nvarchar](50) NOT NULL,
	[rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_SalesTaxRate_rowguid]  DEFAULT (newid()),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesTaxRate_ModifiedDate]  DEFAULT (getdate()),
 );
GO


-- Drop and restore AdventureWorks database
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
	DROP DATABASE AdventureWorks
END
GO


RESTORE DATABASE [AdventureWorks] FROM  DISK = N'$(SUBDIR)SetupFiles\AdventureWorks.bak' WITH  REPLACE,
MOVE N'AdventureWorks' TO N'$(SUBDIR)SetupFiles\AdventureWorks.mdf', 
MOVE N'AdventureWorks_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [AdventureWorks\Student];
GO

EXEC  msdb.dbo.sp_delete_database_backuphistory @database_name = 'AdventureWorks';
GO



