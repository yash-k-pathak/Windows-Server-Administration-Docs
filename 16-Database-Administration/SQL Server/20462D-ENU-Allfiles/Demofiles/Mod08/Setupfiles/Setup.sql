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

USE [AdventureWorks]
GO

/****** Object:  Index [AK_SalesOrderDetail_rowguid]    Script Date: 7/8/2014 1:23:19 AM ******/
DROP INDEX [AK_SalesOrderDetail_rowguid] ON [Sales].[SalesOrderDetail]
GO


/****** Object:  Index [IX_SalesOrderDetail_ProductID]    Script Date: 7/8/2014 1:23:29 AM ******/
DROP INDEX [IX_SalesOrderDetail_ProductID] ON [Sales].[SalesOrderDetail]
GO


/****** Object:  Index [AK_SalesOrderHeader_rowguid]    Script Date: 7/8/2014 1:23:57 AM ******/
DROP INDEX [AK_SalesOrderHeader_rowguid] ON [Sales].[SalesOrderHeader]
GO


/****** Object:  Index [AK_SalesOrderHeader_SalesOrderNumber]    Script Date: 7/8/2014 1:24:15 AM ******/
DROP INDEX [AK_SalesOrderHeader_SalesOrderNumber] ON [Sales].[SalesOrderHeader]
GO

/****** Object:  Index [IX_SalesOrderHeader_CustomerID]    Script Date: 7/8/2014 1:24:28 AM ******/
DROP INDEX [IX_SalesOrderHeader_CustomerID] ON [Sales].[SalesOrderHeader]
GO


/****** Object:  Index [IX_SalesOrderHeader_SalesPersonID]    Script Date: 7/8/2014 1:24:40 AM ******/
DROP INDEX [IX_SalesOrderHeader_SalesPersonID] ON [Sales].[SalesOrderHeader]
GO





