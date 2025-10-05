USE master
GO

-- drop encryption keys
DROP CERTIFICATE BackupCert;
GO
DROP MASTER KEY;
GO


CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
GO

-- Back up the database master key
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'Pa$$w0rd';
BACKUP MASTER KEY TO FILE = N'$(SUBDIR)master.key'
	ENCRYPTION BY PASSWORD = 'MasterPa$$w0rd';
GO

-- Create a certificate
CREATE CERTIFICATE BackupCert
	WITH SUBJECT = 'Backup Encryption Certificate';
GO

-- Back up the certificate and its private key
BACKUP CERTIFICATE BackupCert TO FILE = N'$(SUBDIR)Backup.cer'
WITH PRIVATE KEY (	FILE = N'$(SUBDIR)Backup.key' ,
					ENCRYPTION BY PASSWORD = 'CertPa$$w0rd');
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

-- Back up AdventureWorks
BACKUP DATABASE AdventureWorks TO DISK = N'$(SUBDIR)AW.bak'
WITH FORMAT, INIT, COMPRESSION, NAME = 'AdventureWorks-Full Database Backup';
GO

UPDATE AdventureWorks.Production.Product
SET ListPrice = ListPrice * 1.1;
GO

BACKUP DATABASE AdventureWorks TO DISK = N'$(SUBDIR)AW.bak'
WITH NOFORMAT, NOINIT, DIFFERENTIAL, COMPRESSION, NAME = 'AdventureWorks-Diff Database Backup';
GO

UPDATE AdventureWorks.Production.Product
SET ListPrice = ListPrice * 1.1;
GO

BACKUP LOG AdventureWorks TO DISK = N'$(SUBDIR)AW.bak'
WITH NOFORMAT, NOINIT, COMPRESSION, NAME = 'AdventureWorks-Transaction Log Backup';
GO

UPDATE AdventureWorks.Production.Product
SET ListPrice = ListPrice * 1.1;
GO

-- Restore AdventureWorksEncypt

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorksEncrypt')
BEGIN
	DROP DATABASE AdventureWorksEncrypt
END
GO

RESTORE DATABASE [AdventureWorksEncrypt] FROM  DISK = N'$(SUBDIR)SetupFiles\AdventureWorks.bak' WITH  REPLACE,
MOVE N'AdventureWorks' TO N'$(SUBDIR)SetupFiles\AdventureWorksEncrypt.mdf', 
MOVE N'AdventureWorks_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorksEncrypt_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorksEncrypt TO [AdventureWorks\Student];
GO


BACKUP DATABASE AdventureWorksEncrypt TO DISK = N'$(SUBDIR)AW_Encrypt.bak'
WITH FORMAT, INIT, COMPRESSION, NAME = 'AdventureWorks-Encrypted Database Backup',
ENCRYPTION (ALGORITHM = AES_128, SERVER CERTIFICATE = [BackupCert]);
GO

DROP DATABASE AdventureWorksEncrypt;

EXEC  msdb.dbo.sp_delete_database_backuphistory @database_name = 'AdventureWorksEncrypt';
GO



