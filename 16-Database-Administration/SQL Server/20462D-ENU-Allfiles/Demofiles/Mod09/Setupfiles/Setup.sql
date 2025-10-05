USE master
GO

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'ContainedDB')
BEGIN
	DROP DATABASE ContainedDB
END
GO

-- Drop and restore AdventureWorks database
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
	DROP DATABASE AdventureWorks
END
GO

DROP LOGIN [Payroll_Application]
GO

DROP LOGIN [Web_Application]
GO

DROP LOGIN [ADVENTUREWORKS\AnthonyFrizzell]
GO

DROP LOGIN [ADVENTUREWORKS\Database_Managers]
GO

DROP LOGIN [ADVENTUREWORKS\HumanResources_Users]
GO


DROP SERVER ROLE [AW_securitymanager]
GO


RESTORE DATABASE [AdventureWorks] FROM  DISK = N'$(SUBDIR)SetupFiles\AdventureWorks.bak' WITH  REPLACE,
MOVE N'AdventureWorks' TO N'$(SUBDIR)SetupFiles\AdventureWorks.mdf', 
MOVE N'AdventureWorks_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [AdventureWorks\Student];
GO

EXEC  msdb.dbo.sp_delete_database_backuphistory @database_name = 'AdventureWorks';
GO



