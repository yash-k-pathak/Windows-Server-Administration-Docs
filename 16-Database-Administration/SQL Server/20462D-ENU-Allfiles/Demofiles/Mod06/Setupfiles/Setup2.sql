USE master
GO

-- Drop Finance
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'Finance')
	DROP DATABASE Finance;
GO


-- Drop AdventureWorks
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
	DROP DATABASE AdventureWorks
END
GO

