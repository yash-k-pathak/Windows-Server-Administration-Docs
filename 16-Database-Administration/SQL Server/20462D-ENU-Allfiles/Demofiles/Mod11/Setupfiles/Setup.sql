USE master
GO

-- delete maintenance plans
WHILE EXISTS (SELECT * FROM msdb.dbo.sysmaintplan_plans)
BEGIN
	DECLARE @id NVARCHAR(50);
	SELECT @id = MAX (id) FROM msdb.dbo.sysmaintplan_plans;
	EXECUTE msdb.dbo.sp_maintplan_delete_plan @plan_id = @id;
END


-- Drop CorruptDB
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'CorruptDB')
BEGIN
	DROP DATABASE CorruptDB
END
GO


RESTORE DATABASE [CorruptDB] FROM  DISK = N'$(SUBDIR)SetupFiles\CorruptDB.bak' WITH  REPLACE,
MOVE 'Northwind' TO N'$(SUBDIR)SetupFiles\CorruptDB.mdf',
MOVE 'Northwind_Log' TO N'$(SUBDIR)SetupFiles\CorruptDB.ldf';
GO
ALTER AUTHORIZATION ON DATABASE::CorruptDB TO [AdventureWorks\Student];
GO

EXEC  msdb.dbo.sp_delete_database_backuphistory @database_name = 'CorruptDB';
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



