
-- Create DMK
USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
GO

-- Create server certificate
Use master;
CREATE CERTIFICATE TDE_Server_Cert
WITH SUBJECT = 'TDE Server Certificate';
GO

BACKUP CERTIFICATE TDE_Server_Cert
  TO FILE = 'D:\Demofiles\Mod10\TDE_Server_Cert.cer'
  WITH PRIVATE KEY
      (FILE = 'D:\Demofiles\Mod10\TDE_Server_Cert.key' ,
	   ENCRYPTION BY PASSWORD = 'CertPa$$w0rd');


--Create DEK
USE ConfidentialDB;
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE TDE_Server_Cert;


--Enable encryption
USE master;
ALTER DATABASE ConfidentialDB
SET ENCRYPTION ON;

SELECT name, is_encrypted FROM sys.databases;