USE master
GO

-- delete maintenance plans
WHILE EXISTS (SELECT * FROM msdb.dbo.sysmaintplan_plans)
BEGIN
	DECLARE @id NVARCHAR(50);
	SELECT @id = MAX (id) FROM msdb.dbo.sysmaintplan_plans;
	EXECUTE msdb.dbo.sp_maintplan_delete_plan @plan_id = @id;
END

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


-- restore databases
RESTORE DATABASE HumanResources FROM  DISK = N'$(SUBDIR)SetupFiles\HumanResources.bak' WITH REPLACE;
GO
ALTER AUTHORIZATION ON DATABASE::HumanResources TO [AdventureWorks\Student];
GO

EXEC  msdb.dbo.sp_delete_database_backuphistory @database_name = 'HumanResources';
GO


RESTORE DATABASE [InternetSales] FROM  DISK = N'$(SUBDIR)SetupFiles\CorruptDB.bak' WITH  REPLACE,
MOVE 'Northwind' TO N'M:\Data\InternetSales.mdf',
MOVE 'Northwind_Log' TO N'L:\Logs\InternetSales.ldf';
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


-- Set the recovery model for AWDataWarehouse
ALTER DATABASE AWDataWarehouse SET RECOVERY SIMPLE WITH NO_WAIT;
GO

-- Create a clustered idnex on HumanResources
CREATE CLUSTERED INDEX idx_Employee_BusinessEntityID
ON HumanResources.Employees.Employee (BusinessEntityID);
GO

-- Modify the data in the table 
SET NOCOUNT ON;
DECLARE @Counter int = (SELECT MIN(BusinessEntityID) FROM HumanResources.Employees.Employee);
DECLARE @maxEmp int = (SELECT MAX(BusinessEntityID) FROM HumanResources.Employees.Employee);
WHILE @Counter <= @maxEmp BEGIN
  UPDATE HumanResources.Employees.Employee SET PhoneNumber = '555-123' + CONVERT(varchar(5),@Counter)
    WHERE BusinessEntityID = @Counter;
  SET @Counter += 1;
END;
GO

SET NOCOUNT ON;
DECLARE @Counter int = (SELECT MIN(BusinessEntityID) FROM HumanResources.Employees.Employee);
DECLARE @maxEmp int = (SELECT MAX(BusinessEntityID) FROM HumanResources.Employees.Employee);
WHILE @Counter <= @maxEmp BEGIN
  UPDATE HumanResources.Employees.Employee SET EmailAddress = REPLACE(EmailAddress, 'adventure-works.com', 'adventureworks.msft')
    WHERE BusinessEntityID = @Counter;
  SET @Counter += 1;
END;
GO