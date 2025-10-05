
-- Create a database master key
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
GO

-- Back up the database master key
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'Pa$$w0rd';
BACKUP MASTER KEY TO FILE = 'D:\Demofiles\Mod04\master.key'
	ENCRYPTION BY PASSWORD = 'MasterPa$$w0rd';
GO

-- Create a certificate
CREATE CERTIFICATE BackupCert
	WITH SUBJECT = 'Backup Encryption Certificate';
GO

-- Back up the certificate and its private key
BACKUP CERTIFICATE BackupCert TO FILE = 'D:\Demofiles\Mod04\Backup.cer'
WITH PRIVATE KEY (	FILE = 'D:\Demofiles\Mod04\Backup.key' ,
					ENCRYPTION BY PASSWORD = 'CertPa$$w0rd');
GO

