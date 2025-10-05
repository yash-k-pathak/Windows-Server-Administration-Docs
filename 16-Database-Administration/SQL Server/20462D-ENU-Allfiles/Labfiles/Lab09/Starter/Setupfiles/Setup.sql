USE master
GO

-- drop databases
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'HumanResources')
BEGIN
	DROP DATABASE HumanResources
END
GO

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'InternetSales')
BEGIN
	DROP DATABASE InternetSales
END
GO

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AWDataWarehouse')
BEGIN
	DROP DATABASE AWDataWarehouse
END
GO

-- Drop server roles and logins
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Marketing_Application')
BEGIN
	DROP LOGIN [Marketing_Application];
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ADVENTUREWORKS\WebApplicationSvc')
BEGIN
	DROP LOGIN [ADVENTUREWORKS\WebApplicationSvc];
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ADVENTUREWORKS\InternetSales_Users')
BEGIN
	DROP LOGIN [ADVENTUREWORKS\InternetSales_Users];
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ADVENTUREWORKS\InternetSales_Managers')
BEGIN
	DROP LOGIN [ADVENTUREWORKS\InternetSales_Managers];
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ADVENTUREWORKS\Database_Managers')
BEGIN
	DROP LOGIN [ADVENTUREWORKS\Database_Managers];
END
GO

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'application_admin')
BEGIN
	DROP SERVER ROLE application_admin;
END
GO

-- restore databases
RESTORE DATABASE HumanResources FROM  DISK = N'$(SUBDIR)SetupFiles\HumanResources.bak' WITH REPLACE;
GO
ALTER AUTHORIZATION ON DATABASE::HumanResources TO [AdventureWorks\Student];
GO

EXEC  msdb.dbo.sp_delete_database_backuphistory @database_name = 'HumanResources';
GO


RESTORE DATABASE InternetSales FROM  DISK = N'$(SUBDIR)SetupFiles\InternetSales.bak' WITH REPLACE;
GO
ALTER AUTHORIZATION ON DATABASE::InternetSales TO [AdventureWorks\Student];
GO

EXEC  msdb.dbo.sp_delete_database_backuphistory @database_name = 'InternetSales';
GO


RESTORE DATABASE AWDataWarehouse FROM  DISK = N'$(SUBDIR)SetupFiles\AWDataWarehouse.bak' WITH REPLACE;
GO
ALTER AUTHORIZATION ON DATABASE::AWDataWarehouse TO [AdventureWorks\Student];
GO

EXEC  msdb.dbo.sp_delete_database_backuphistory @database_name = 'AWDataWarehouse';
GO


-- Set recovery model for HumanResources
ALTER DATABASE HumanResources SET RECOVERY SIMPLE WITH NO_WAIT;
GO


-- Set the recovery model for InternetSales
ALTER DATABASE InternetSales SET RECOVERY FULL WITH NO_WAIT;
GO


-- Set the recovery model for AWDataWarehouse
ALTER DATABASE AWDataWarehouse SET RECOVERY SIMPLE WITH NO_WAIT;
GO


