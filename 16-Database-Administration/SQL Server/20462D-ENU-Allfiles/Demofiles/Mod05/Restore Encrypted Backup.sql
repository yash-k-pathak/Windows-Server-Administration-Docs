-- Try to restore an encrypted backup
RESTORE DATABASE AdventureWorksEncrypt
FROM DISK = 'D:\Demofiles\Mod05\AW_Encrypt.bak';


-- Create a database master key for master
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
GO

-- Import the backed up certificate
CREATE CERTIFICATE BackupCert
FROM FILE = 'D:\Demofiles\Mod05\Backup.cer'
WITH PRIVATE KEY (
	DECRYPTION BY PASSWORD = 'CertPa$$w0rd',
	FILE = 'D:\Demofiles\Mod05\Backup.key');
GO

--Restore the encrypted database
RESTORE DATABASE AdventureWorksEncrypt
FROM DISK = 'D:\Demofiles\Mod05\AW_Encrypt.bak';
GO