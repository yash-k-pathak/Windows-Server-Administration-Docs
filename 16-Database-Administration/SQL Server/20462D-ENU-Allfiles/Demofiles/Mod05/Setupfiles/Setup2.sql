USE master
GO

-- Drop and restore AdventureWorks database
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorksEncrypt')
BEGIN
	DROP DATABASE AdventureWorksEncrypt
END
GO

-- drop encryption keys
DROP CERTIFICATE BackupCert;
GO
DROP MASTER KEY;
GO

