USE master
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


--Reset multi-server jobs
EXECUTE msdb.dbo.sp_delete_targetserver @server_name = 'MIA-SQL\SQL2';

IF EXISTS (select * from msdb.dbo.sysjobs WHERE name = N'Backup master database')
EXEC msdb.dbo.sp_delete_job @job_name=N'Backup master database', @delete_unused_schedule=1
GO

-- Delete jobs, proxies and credentials
IF EXISTS (select * from msdb.dbo.sysjobs WHERE name = N'Check AdventureWorks DB')
EXEC msdb.dbo.sp_delete_job @job_name=N'Check AdventureWorks DB', @delete_unused_schedule=1
GO

IF EXISTS (select * from msdb.dbo.sysjobs WHERE name = N'Back Up Database - AdventureWorks')
EXEC msdb.dbo.sp_delete_job @job_name=N'Back Up Database - AdventureWorks', @delete_unused_schedule=1
GO

USE [msdb]
GO
IF EXISTS (select * from msdb.dbo.sysproxies where name = 'FileAgentProxy')
EXEC msdb.dbo.sp_delete_proxy @proxy_name=N'FileAgentProxy'
GO

USE [master]
GO
IF EXISTS (select * from sys.credentials where name = 'FileAgent')
DROP CREDENTIAL [FileAgent]
GO

