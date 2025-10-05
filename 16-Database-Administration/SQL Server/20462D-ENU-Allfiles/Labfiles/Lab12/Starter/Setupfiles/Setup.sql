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

-- Create a clustered idnex on HumanResources
CREATE CLUSTERED INDEX idx_Employee_BusinessEntityID
ON HumanResources.Employees.Employee (BusinessEntityID);
GO


--Reset multi-server jobs (in case students did the demo)
EXECUTE msdb.dbo.sp_delete_targetserver @server_name = 'MIA-SQL\SQL2';

IF EXISTS (select * from msdb.dbo.sysjobs WHERE name = N'Backup master database')
EXEC msdb.dbo.sp_delete_job @job_name=N'Backup master database', @delete_unused_schedule=1
GO

-- Delete jobs, proxies and credentials
IF EXISTS (select * from msdb.dbo.sysjobs WHERE name = N'Backup HumanResources')
EXEC msdb.dbo.sp_delete_job @job_name=N'Backup HumanResources', @delete_unused_schedule=1
GO


USE [msdb]
GO
IF EXISTS (select * from msdb.dbo.sysproxies where name = 'FileAgent_Proxy')
EXEC msdb.dbo.sp_delete_proxy @proxy_name=N'FileAgent_Proxy'
GO

USE [master]
GO
IF EXISTS (select * from sys.credentials where name = 'FileAgent_Credential')
DROP CREDENTIAL [FileAgent_Credential]
GO

-- Drop and recreate SQL_Helper Login
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Backup_User')
BEGIN
	DROP LOGIN [Backup_User];
END
GO

CREATE LOGIN Backup_User
WITH PASSWORD = 'Pa$$w0rd',
CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

USE HumanResources;
GO
CREATE USER Backup_User
FOR LOGIN Backup_User;
GO
ALTER ROLE db_backupoperator
ADD MEMBER Backup_User;
GO


