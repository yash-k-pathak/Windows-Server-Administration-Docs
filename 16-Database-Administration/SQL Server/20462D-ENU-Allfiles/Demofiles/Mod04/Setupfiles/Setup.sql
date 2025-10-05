USE master
GO

-- drop encryption keys
DROP CERTIFICATE BackupCert;
GO
DROP MASTER KEY;
GO

-- Create log Test
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'LogTest')
	DROP DATABASE LogTest;
GO

CREATE DATABASE LogTest ON  PRIMARY 
(  NAME = N'LogTest', 
   FILENAME = N'$(SUBDIR)SetupFiles\LogTest.mdf' , 
   SIZE = 10240KB, 
   FILEGROWTH = 1024KB 
)
 LOG ON 
( NAME = N'LogTest_log', 
  FILENAME = N'$(SUBDIR)SetupFiles\LogTest_log.ldf' , 
  SIZE = 5120KB, 
  FILEGROWTH = 10%
);
GO

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = 'LogTest';
GO

-- Set the full recovery model
ALTER DATABASE LogTest SET RECOVERY FULL;
GO

--  Create a table in the database
CREATE TABLE LogTest.dbo.DemoTable
( DemoTableId int IDENTITY(1,1) PRIMARY KEY,
  FirstLargeColumn nvarchar(600),
  BigIntColumn bigint
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



